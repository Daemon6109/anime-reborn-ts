import { OnStart, Service } from "@flamework/core";
import { Players, RunService } from "@rbxts/services";
import Signal from "@rbxts/signal";

// Placeholder types and interfaces (to be properly defined later)
interface DataCache {
	TeamEventData: {
		Team: string;
		ContributedSouls: number;
		ContributedReaperParts: number;
	};
	Currencies: Record<string, number>;
}

interface Person {
	player: Player;
	dataCache: (fn?: (data: DataCache) => DataCache) => DataCache;
}

// Mock Person module
const Person = {
	getForPlayer: (player: Player): Person | undefined => {
		// Mock implementation - would be replaced with actual Person module
		return undefined;
	},
	personAdded: new Signal<(person: Person) => void>(),
};

interface TeamEventConfig {
	name: string;
	description: string;
	teams: string[];
	startTime: number; // Unix timestamp
	endTime: number; // Unix timestamp
	rewards: Record<
		string, // team name
		Record<number, Record<string, number>> // placement -> rewards
	>;
}

interface TeamRanking {
	team: string;
	contribution: number;
}

/**
 * Team event system for managing competitive team-based events.
 */
@Service({})
export class TeamEventsService implements OnStart {
	public readonly version = { major: 1, minor: 0, patch: 0 };

	// Events
	public readonly teamJoined = new Signal<(player: Player, teamName: string) => void>();
	public readonly pointsEarned = new Signal<(player: Player, teamName: string, points: number) => void>();
	public readonly eventEnded = new Signal<(eventId: string) => void>();

	// Active events
	private readonly activeEvents = new Map<string, TeamEventConfig>();

	// Global team balancing
	private teamBalanceValue = 50000;

	onStart(): void {
		this.setupPeriodicTasks();
		this.loadDefaultEvents();
		this.setupPersonEvents();
		print("🏆 TeamEventsService started");
	}

	/**
	 * Sets up periodic tasks for event management
	 */
	private setupPeriodicTasks(): void {
		// Check event status every minute
		task.spawn(() => {
			for (;;) {
				task.wait(60);
				this.checkEventStatus();
			}
		});
	}

	/**
	 * Sets up person-related events
	 */
	private setupPersonEvents(): void {
		Person.personAdded.Connect((person) => {
			this.assignTeamIfNeeded(person);
		});
	}

	/**
	 * Checks if an event is currently active
	 */
	private isEventActive(config: TeamEventConfig): boolean {
		const currentTime = os.time();
		return currentTime >= config.startTime && currentTime <= config.endTime;
	}

	/**
	 * Selects a team based on balance considerations
	 */
	private selectBalancedTeam(teams: string[]): string {
		// Simple balancing: alternate between teams based on team balance value
		const teamIndex = (this.teamBalanceValue % teams.size()) + 1;
		this.updateTeamBalanceValue(1);

		return teams[teamIndex - 1]; // Convert to 0-based index
	}

	/**
	 * Updates the team balance value
	 */
	private updateTeamBalanceValue(addValue: number): void {
		this.teamBalanceValue = this.teamBalanceValue + addValue;
	}

	/**
	 * Joins a player to a team
	 */
	public joinTeam(person: Person, teamName: string): boolean {
		// Find an active event that has this team
		let activeEvent: TeamEventConfig | undefined;
		for (const [eventId, config] of this.activeEvents) {
			if (this.isEventActive(config) && config.teams.includes(teamName)) {
				activeEvent = config;
				break;
			}
		}

		if (activeEvent === undefined) {
			return false;
		}

		// Update player data
		person.dataCache((dataCache) => {
			const newDataCache = { ...dataCache };
			const teamEventData = newDataCache.TeamEventData;

			teamEventData.Team = teamName;

			return newDataCache;
		});

		this.teamJoined.Fire(person.player, teamName);
		return true;
	}

	/**
	 * Assigns a team to a player if they don't have one
	 */
	private assignTeamIfNeeded(person: Person): void {
		const dataCache = person.dataCache();
		const teamEventData = dataCache.TeamEventData;

		// Check if player already has a team
		if (teamEventData.Team !== undefined && teamEventData.Team !== "") {
			return;
		}

		// Find active event to assign team for
		for (const [eventId, config] of this.activeEvents) {
			if (this.isEventActive(config)) {
				const assignedTeam = this.selectBalancedTeam(config.teams);
				this.joinTeam(person, assignedTeam);
				break;
			}
		}
	}

	/**
	 * Gives team event rewards to a player
	 */
	private giveTeamRewards(person: Person, rewards: Record<string, number>): void {
		person.dataCache((dataCache) => {
			const newDataCache = { ...dataCache };
			const currencies = newDataCache.Currencies;

			// Give currency rewards
			for (const [rewardType, amount] of pairs(rewards)) {
				if (typeIs(amount, "number")) {
					currencies[rewardType] = (currencies[rewardType] ?? 0) + amount;
				}
			}

			return newDataCache;
		});
	}

	/**
	 * Distributes rewards to all members of a team
	 */
	private distributeTeamRewards(teamName: string, rewards: Record<string, number>): void {
		for (const player of Players.GetPlayers()) {
			const person = Person.getForPlayer(player);
			if (person !== undefined) {
				const dataCache = person.dataCache();
				const teamEventData = dataCache.TeamEventData;

				if (teamEventData.Team === teamName) {
					this.giveTeamRewards(person, rewards);
				}
			}
		}
	}

	/**
	 * Gets the total contribution for a team across all players
	 */
	public getTeamTotalContribution(teamName: string): number {
		let totalContribution = 0;

		for (const player of Players.GetPlayers()) {
			const person = Person.getForPlayer(player);
			if (person !== undefined) {
				const dataCache = person.dataCache();
				const teamEventData = dataCache.TeamEventData;

				if (teamEventData.Team === teamName) {
					totalContribution =
						totalContribution + teamEventData.ContributedSouls + teamEventData.ContributedReaperParts;
				}
			}
		}

		return totalContribution;
	}

	/**
	 * Gets team rankings for active events
	 */
	public getTeamRankings(): TeamRanking[] {
		const teamContributions = new Map<string, number>();
		const rankings: TeamRanking[] = [];

		// Collect contributions for each team
		for (const player of Players.GetPlayers()) {
			const person = Person.getForPlayer(player);
			if (person !== undefined) {
				const dataCache = person.dataCache();
				const teamEventData = dataCache.TeamEventData;

				if (teamEventData.Team !== undefined && teamEventData.Team !== "") {
					const currentContribution = teamContributions.get(teamEventData.Team) ?? 0;
					teamContributions.set(
						teamEventData.Team,
						currentContribution + teamEventData.ContributedSouls + teamEventData.ContributedReaperParts,
					);
				}
			}
		}

		// Convert to ranking array
		for (const [team, contribution] of teamContributions) {
			rankings.push({ team, contribution });
		}

		// Sort by contribution (highest first)
		table.sort(rankings, (a, b) => a.contribution > b.contribution);

		return rankings;
	}

	/**
	 * Ends a team event and distributes rewards
	 */
	private endEvent(eventId: string, config: TeamEventConfig): void {
		const rankings = this.getTeamRankings();

		// Distribute rewards based on rankings
		for (let placement = 1; placement <= rankings.size(); placement++) {
			const rankData = rankings[placement - 1]; // Convert to 0-based index
			if (rankData === undefined) continue;

			const teamName = rankData.team;
			const teamRewards = config.rewards[teamName];
			const rewards = teamRewards?.[placement];

			if (rewards !== undefined) {
				this.distributeTeamRewards(teamName, rewards);
			}
		}

		// Remove from active events
		this.activeEvents.delete(eventId);

		this.eventEnded.Fire(eventId);
	}

	/**
	 * Checks the status of all events and handles endings
	 */
	private checkEventStatus(): void {
		const currentTime = os.time();

		for (const [eventId, config] of this.activeEvents) {
			if (currentTime > config.endTime) {
				this.endEvent(eventId, config);
			}
		}
	}

	/**
	 * Registers a team event
	 */
	public registerEvent(eventId: string, config: TeamEventConfig): void {
		this.activeEvents.set(eventId, config);
	}

	/**
	 * Loads default team events
	 */
	private loadDefaultEvents(): void {
		// Example: Aliens vs Spirits event
		const aliensVsSpirits: TeamEventConfig = {
			name: "Aliens vs Spirits",
			description: "Epic battle between two powerful factions!",
			teams: ["Aliens", "Spirits"],
			startTime: os.time(), // Current time for demo
			endTime: os.time() + 86400 * 7, // One week from now
			rewards: {
				Aliens: {
					1: { Gold: 5000, Gems: 500 }, // 1st place
					2: { Gold: 3000, Gems: 300 }, // 2nd place
				},
				Spirits: {
					1: { Gold: 5000, Gems: 500 }, // 1st place
					2: { Gold: 3000, Gems: 300 }, // 2nd place
				},
			},
		};

		this.registerEvent("aliens_vs_spirits", aliensVsSpirits);
	}

	/**
	 * Awards souls contribution to a player for their team
	 */
	public awardTeamSouls(person: Person, souls: number, reason?: string): void {
		const dataCache = person.dataCache();
		const teamEventData = dataCache.TeamEventData;

		if (teamEventData.Team === undefined || teamEventData.Team === "") {
			return;
		}

		person.dataCache((currentDataCache) => {
			const newDataCache = { ...currentDataCache };
			const newTeamEventData = newDataCache.TeamEventData;

			newTeamEventData.ContributedSouls = newTeamEventData.ContributedSouls + souls;

			return newDataCache;
		});

		this.pointsEarned.Fire(person.player, teamEventData.Team, souls);
	}

	/**
	 * Awards reaper parts contribution to a player for their team
	 */
	public awardTeamReaperParts(person: Person, reaperParts: number, reason?: string): void {
		const dataCache = person.dataCache();
		const teamEventData = dataCache.TeamEventData;

		if (teamEventData.Team === undefined || teamEventData.Team === "") {
			return;
		}

		person.dataCache((currentDataCache) => {
			const newDataCache = { ...currentDataCache };
			const newTeamEventData = newDataCache.TeamEventData;

			newTeamEventData.ContributedReaperParts = newTeamEventData.ContributedReaperParts + reaperParts;

			return newDataCache;
		});

		this.pointsEarned.Fire(person.player, teamEventData.Team, reaperParts);
	}

	/**
	 * Gets the current team for a player
	 */
	public getCurrentTeam(person: Person): string | undefined {
		const dataCache = person.dataCache();
		return dataCache.TeamEventData.Team;
	}

	/**
	 * Gets the team contribution for a player
	 */
	public getPlayerTeamContribution(person: Person): number {
		const dataCache = person.dataCache();
		const teamEventData = dataCache.TeamEventData;
		return teamEventData.ContributedSouls + teamEventData.ContributedReaperParts;
	}

	/**
	 * Gets all active events
	 */
	public getActiveEvents(): ReadonlyMap<string, TeamEventConfig> {
		return this.activeEvents;
	}

	/**
	 * Removes a team event
	 */
	public removeEvent(eventId: string): boolean {
		return this.activeEvents.delete(eventId);
	}
}
