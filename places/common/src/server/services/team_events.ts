import { Service, OnInit, OnStart, Dependency } from "@flamework/core";
import { Players, DataStoreService } from "@rbxts/services";
import { DataService } from "@services/data.service";
import { Signal } from "@rbxts/signal";

const version = { major: 1, minor: 0, patch: 0 };

type Signal<T> = Shingo<T>;

// Create signals for team event events
const teamJoinedEvent = new Shingo<any>();
const pointsEarnedEvent = new Shingo<any>();
const eventEndedEvent = new Shingo<any>();

export interface TeamEventConfig {
	name: string;
	description: string;
	teams: string[];
	startTime: number; // Unix timestamp
	endTime: number; // Unix timestamp
	rewards: {
		[teamName: string]: {
			[placement: number]: { [rewardType: string]: any }; // placement -> rewards
		};
	};
}

interface TeamEventData {
	Team?: string;
	ContributedSouls: number;
	ContributedReaperParts: number;
}

interface PlayerTeamEventDataCache {
	TeamEventData: TeamEventData;
	Currencies: { [key: string]: number };
	// Add other properties from the data cache if necessary
}

//[=[
//   Team event system for managing competitive team-based events.
//
//   @class TeamEvents
//]=]
const TeamEvents = {
	version: version,

	// Events
	teamJoined: teamJoinedEvent,
	pointsEarned: pointsEarnedEvent,
	eventEnded: eventEndedEvent,

	// Active events
	activeEvents: {} as { [eventId: string]: TeamEventConfig },
};

// Global team balancing data store
const TeamBalancingDataStore = MockDataStoreService.GetDataStore("TeamBalancing");
let teamBalanceValue = 50000; // Default value

//[=[
//   Loads the team balance value from the data store.
//
//   @within TeamEvents
//
//   @private
//
//   ```ts
//   loadTeamBalanceValue();
//   ```
//]=]
async function loadTeamBalanceValue(): Promise<void> {
	const [success, result] = await pcall(async () => {
		return TeamBalancingDataStore.UpdateAsync("Value", (newValue?: unknown) => {
			teamBalanceValue = typeIs(newValue, "number") ? newValue : 50000;
			return teamBalanceValue;
		});
	});

	if (!success) {
		warn(`Failed to load team balance value: ${result}`);
	}
}

//[=[
//   Updates the team balance value in the data store.
//
//   @within TeamEvents
//
//   @private
//
//   @param addValue number -- Value to add to the balance
//
//   ```ts
//   updateTeamBalanceValue(1000);
//   ```
//]=]
async function updateTeamBalanceValue(addValue: number): Promise<void> {
	const [success, result] = await pcall(async () => {
		return TeamBalancingDataStore.UpdateAsync("Value", (newValue?: unknown) => {
			const currentVal = typeIs(newValue, "number") ? newValue : 50000;
			teamBalanceValue = currentVal + addValue;
			return teamBalanceValue;
		});
	});

	if (!success) {
		warn(`Failed to update team balance value: ${result}`);
	}
}

//[=[
//   Checks if an event is currently active.
//
//   @within TeamEvents
//
//   @private
//
//   @param config TeamEventConfig -- The event configuration
//
//   @return boolean -- Whether the event is active
//
//   ```ts
//   const isActive = isEventActive(eventConfig);
//   ```
//]=]
function isEventActive(config: TeamEventConfig): boolean {
	const currentTime = os.time();
	return currentTime >= config.startTime && currentTime <= config.endTime;
}

//[=[
//   Selects a team based on balance considerations.
//
//   @within TeamEvents
//
//   @private
//
//   @param teams string[] -- Available teams
//
//   @return string -- Selected team name
//
//   ```ts
//   const selectedTeam = selectBalancedTeam(["TeamA", "TeamB"]);
//   ```
//]=]
function selectBalancedTeam(teams: string[]): string {
	// Simple balancing: alternate between teams based on team balance value
	const teamIndex = (teamBalanceValue % teams.size()) + 1;
	updateTeamBalanceValue(1);

	return teams[teamIndex - 1]; // Adjust for 0-based indexing if needed, Lua is 1-based
}

//[=[
//   Joins a player to a team.
//
//   @within TeamEvents
//
//   @param person Person -- The person joining the team
//   @param teamName string -- The team to join
//
//   @return boolean -- Whether the join was successful
//
//   ```ts
//   const success = joinTeam(person, "TeamA");
//   ```
//]=]
function joinTeam(person: Person, teamName: string): boolean {
	// Find an active event that has this team
	let activeEvent: TeamEventConfig | undefined = undefined;
	for (const [eventId, config] of pairs(TeamEvents.activeEvents)) {
		if (isEventActive(config) && config.teams.includes(teamName)) {
			activeEvent = config;
			break;
		}
	}

	if (!activeEvent) {
		return false;
	}

	// Update player data
	person.dataCache((dataCache) => {
		const newDataCache = { ...dataCache } as PlayerTeamEventDataCache;
		newDataCache.TeamEventData.Team = teamName;
		return newDataCache;
	});

	teamJoinedEvent.fire(person.player, teamName);
	return true;
}

//[=[
//   Assigns a team to a player if they don't have one.
//
//   @within TeamEvents
//
//   @private
//
//   @param person Person -- The person to assign a team to
//
//   ```ts
//   assignTeamIfNeeded(person);
//   ```
//]=]
function assignTeamIfNeeded(person: Person): void {
	const dataCache = person.dataCache() as PlayerTeamEventDataCache;
	const teamEventData = dataCache.TeamEventData;

	// Check if player already has a team
	if (teamEventData.Team && teamEventData.Team !== "") {
		return;
	}

	// Find active event to assign team for
	for (const [eventId, config] of pairs(TeamEvents.activeEvents)) {
		if (isEventActive(config)) {
			const assignedTeam = selectBalancedTeam(config.teams);
			joinTeam(person, assignedTeam);
			break;
		}
	}
}

//[=[
//   Gives team event rewards to a player.
//
//   @within TeamEvents
//
//   @private
//
//   @param person Person -- The person to give rewards to
//   @param rewards { [rewardType: string]: any } -- The rewards to give
//
//   ```ts
//   giveTeamRewards(person, { Gold: 1000, Gems: 500 });
//   ```
//]=]
function giveTeamRewards(person: Person, rewards: { [rewardType: string]: any }): void {
	person.dataCache((dataCache) => {
		const newDataCache = { ...dataCache } as PlayerTeamEventDataCache;
		const currencies = newDataCache.Currencies;

		// Give currency rewards
		for (const [rewardType, amount] of pairs(rewards)) {
			if (typeIs(amount, "number")) {
				currencies[rewardType as string] = (currencies[rewardType as string] || 0) + amount;
			}
		}

		return newDataCache;
	});
}

//[=[
//   Distributes rewards to all members of a team.
//
//   @within TeamEvents
//
//   @private
//
//   @param teamName string -- The team name
//   @param rewards { [rewardType: string]: any } -- The rewards to distribute
//
//   ```ts
//   distributeTeamRewards("TeamA", { Gold: 1000, Gems: 500 });
//   ```
//]=]
async function distributeTeamRewards(teamName: string, rewards: { [rewardType: string]: any }): Promise<void> {
	for (const player of Players.GetPlayers()) {
		const person = await Person.getForPlayer(player);
		if (person) {
			const dataCache = person.dataCache() as PlayerTeamEventDataCache;
			const teamEventData = dataCache.TeamEventData;

			if (teamEventData.Team === teamName) {
				giveTeamRewards(person, rewards);
			}
		}
	}
}

//[=[
//   Gets the total contribution for a team across all players.
//
//   @within TeamEvents
//
//   @param teamName string -- The team name
//
//   @return number -- Total team contribution (souls + reaper parts)
//
//   ```ts
//   const totalContribution = await getTeamTotalContribution("TeamA");
//   ```
//]=]
async function getTeamTotalContribution(teamName: string): Promise<number> {
	let totalContribution = 0;

	for (const player of Players.GetPlayers()) {
		const person = await Person.getForPlayer(player);
		if (person) {
			const dataCache = person.dataCache() as PlayerTeamEventDataCache;
			const teamEventData = dataCache.TeamEventData;

			if (teamEventData.Team === teamName) {
				totalContribution += teamEventData.ContributedSouls + teamEventData.ContributedReaperParts;
			}
		}
	}

	return totalContribution;
}

//[=[
//   Gets team rankings for active events.
//
//   @within TeamEvents
//
//   @return Promise<{ team: string; contribution: number }[]> -- Sorted team rankings
//
//   ```ts
//   const rankings = await getTeamRankings();
//   ```
//]=]
async function getTeamRankings(): Promise<{ team: string; contribution: number }[]> {
	const teamContributions: { [team: string]: number } = {};
	const rankings: { team: string; contribution: number }[] = [];

	// Collect contributions for each team
	for (const player of Players.GetPlayers()) {
		const person = await Person.getForPlayer(player);
		if (person) {
			const dataCache = person.dataCache() as PlayerTeamEventDataCache;
			const teamEventData = dataCache.TeamEventData;

			if (teamEventData.Team && teamEventData.Team !== "") {
				teamContributions[teamEventData.Team] =
					(teamContributions[teamEventData.Team] || 0) +
					teamEventData.ContributedSouls +
					teamEventData.ContributedReaperParts;
			}
		}
	}

	// Convert to ranking array
	for (const [team, contribution] of pairs(teamContributions)) {
		rankings.push({ team: team as string, contribution: contribution as number });
	}

	// Sort by contribution (highest first)
	rankings.sort((a, b) => b.contribution - a.contribution);

	return rankings;
}

//[=[
//   Ends a team event and distributes rewards.
//
//   @within TeamEvents
//
//   @private
//
//   @param eventId string -- The event identifier
//   @param config TeamEventConfig -- The event configuration
//
//   ```ts
//   endEvent("event_id", eventConfig);
//   ```
//]=]
async function endEvent(eventId: string, config: TeamEventConfig): Promise<void> {
	const rankings = await getTeamRankings();

	// Distribute rewards based on rankings
	for (const [placement_lua, rankData] of ipairs(rankings)) {
		const placement = placement_lua as number; // Lua ipairs is 1-based
		const teamName = rankData.team;
		const rewardsByPlacement = config.rewards[teamName];
		const actualRewards = rewardsByPlacement && rewardsByPlacement[placement];

		if (actualRewards) {
			distributeTeamRewards(teamName, actualRewards);
		}
	}

	// Remove from active events
	delete TeamEvents.activeEvents[eventId];

	eventEndedEvent.fire(eventId);
}

//[=[
//   Checks the status of all events and handles endings.
//
//   @within TeamEvents
//
//   @private
//
//   ```ts
//   checkEventStatus();
//   ```
//]=]
function checkEventStatus(): void {
	const currentTime = os.time();

	for (const [eventId, config] of pairs(TeamEvents.activeEvents)) {
		if (currentTime > config.endTime) {
			endEvent(eventId as string, config);
		}
	}
}

//[=[
//   Registers a team event.
//
//   @within TeamEvents
//
//   @param eventId string -- The event identifier
//   @param config TeamEventConfig -- The event configuration
//
//   ```ts
//   registerEvent("event_id", eventConfig);
//   ```
//]=]
function registerEvent(eventId: string, config: TeamEventConfig): void {
	TeamEvents.activeEvents[eventId] = config;
}

//[=[
//   Loads default team events.
//
//   @within TeamEvents
//
//   @private
//
//   ```ts
//   loadDefaultEvents();
//   ```
//]=]
function loadDefaultEvents(): void {
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

	registerEvent("aliens_vs_spirits", aliensVsSpirits);
}

//[=[
//   Awards souls contribution to a player for their team.
//
//   @within TeamEvents
//
//   @param person Person -- The person earning souls
//   @param souls number -- The souls to contribute
//   @param reason string? -- Optional reason for the contribution
//
//   ```ts
//   awardTeamSouls(person, 100, "Completed a quest");
//   ```
//]=]
function awardTeamSouls(person: Person, souls: number, reason?: string): void {
	const dataCache = person.dataCache() as PlayerTeamEventDataCache;
	const teamEventData = dataCache.TeamEventData;

	if (!teamEventData.Team || teamEventData.Team === "") {
		return;
	}

	person.dataCache((currentDataCache) => {
		const newDataCache = { ...currentDataCache } as PlayerTeamEventDataCache;
		const newTeamEventData = newDataCache.TeamEventData;
		newTeamEventData.ContributedSouls += souls;
		return newDataCache;
	});

	pointsEarnedEvent.fire(person.player, teamEventData.Team, souls);
}

//[=[
//   Awards reaper parts contribution to a player for their team.
//
//   @within TeamEvents
//
//   @param person Person -- The person earning reaper parts
//   @param reaperParts number -- The reaper parts to contribute
//   @param reason string? -- Optional reason for the contribution
//
//   ```ts
//   awardTeamReaperParts(person, 50, "Defeated a boss");
//   ```
//]=]
function awardTeamReaperParts(person: Person, reaperParts: number, reason?: string): void {
	const dataCache = person.dataCache() as PlayerTeamEventDataCache;
	const teamEventData = dataCache.TeamEventData;

	if (!teamEventData.Team || teamEventData.Team === "") {
		return;
	}

	person.dataCache((currentDataCache) => {
		const newDataCache = { ...currentDataCache } as PlayerTeamEventDataCache;
		const newTeamEventData = newDataCache.TeamEventData;
		newTeamEventData.ContributedReaperParts += reaperParts;
		return newDataCache;
	});

	pointsEarnedEvent.fire(person.player, teamEventData.Team, reaperParts);
}

//[=[
//   Gets the current team for a player.
//
//   @within TeamEvents
//
//   @param person Person -- The person to check
//
//   @return string | undefined -- The current team name
//
//   ```ts
//   const currentTeam = getCurrentTeam(person);
//   ```
//]=]
function getCurrentTeam(person: Person): string | undefined {
	const dataCache = person.dataCache() as PlayerTeamEventDataCache;
	return dataCache.TeamEventData.Team;
}

//[=[
//   Gets the team contribution for a player.
//
//   @within TeamEvents
//
//   @param person Person -- The person to check
//
//   @return number -- The player's total team contribution
//
//   ```ts
//   const teamContribution = getPlayerTeamContribution(person);
//   ```
//]=]
function getPlayerTeamContribution(person: Person): number {
	const dataCache = person.dataCache() as PlayerTeamEventDataCache;
	const teamEventData = dataCache.TeamEventData;
	return teamEventData.ContributedSouls + teamEventData.ContributedReaperParts;
}

//[=[
//   This function is used to start the provider and initialize any necessary systems.
//
//   ```ts
//   start();
//   ```
//]=]
async function start(): Promise<void> {
	// Set up network events
	Network.JoinTeam.on(async (player, teamId: string) => {
		const person = await Person.getForPlayer(player);
		if (!person) {
			return;
		}
		joinTeam(person, teamId);
	});
	// Set up periodic event checks
	task.spawn(() => {
		while (true) {
			task.wait(60); // Check every minute
			checkEventStatus();
		}
	});

	// Load default events
	loadDefaultEvents();
}

//[=[
//   This function is used for initialization. It should be called before `start()` to set up the provider.
//
//   ```ts
//   init();
//   ```
//]=]
async function init(): Promise<void> {
	// Load team balance value
	await loadTeamBalanceValue();

	// Set up person events
	Person.personAdded.Connect((person) => {
		assignTeamIfNeeded(person);
	});
}

export default {
	version: version,

	// Functions
	start: start,
	init: init,
	joinTeam: joinTeam,
	awardTeamSouls: awardTeamSouls,
	awardTeamReaperParts: awardTeamReaperParts,
	getCurrentTeam: getCurrentTeam,
	getPlayerTeamContribution: getPlayerTeamContribution,
	getTeamTotalContribution: getTeamTotalContribution,
	getTeamRankings: getTeamRankings,
	registerEvent: registerEvent,

	// Events
	teamJoined: teamJoinedEvent,
	pointsEarned: pointsEarnedEvent,
	eventEnded: eventEndedEvent,
};
