import { Service, OnInit } from "@flamework/core";
import { DataStore } from "@services/player-data";
import { safePlayerAdded } from "@shared/utils/safe-player-added.util";

const version = { major: 1, minor: 0, patch: 0 };

export interface AdventCalendarConfig {
	Name: string; // Calendar name (e.g., "WinterEvent2024")
	StartDate: [number, number, number];
	EndDate: [number, number, number]; // [year, month, day]
	TargetHour: number;
	TargetMin: number;
	Rewards: { [day: number]: { [key: string]: unknown } };
}

/**
 * Advent calendar system for managing time-limited daily rewards during special events.
 */
@Service()
export class AdventCalendarService implements OnInit {
	public readonly version = version;

	// Configuration
	private config: AdventCalendarConfig | undefined = undefined;

	constructor(private readonly dataService: DataStore) {}

	public onInit(): void {
		// Initialize with default config for winter event
		this.setConfig({
			Name: "WinterEvent2024",
			StartDate: [2024, 12, 1],
			EndDate: [2024, 12, 25],
			TargetHour: 0,
			TargetMin: 0,
			Rewards: {
				1: { Currencies: { Gold: 1000, Gems: 10 } },
				2: { Currencies: { Gold: 1200, Gems: 12 } },
				3: { Currencies: { Gold: 1500, Gems: 15 }, Items: { SpecialItem: 1 } },
				// Add more days as needed
			},
		});

		// Handle player joining to update advent calendar data
		safePlayerAdded((player) => {
			task.spawn(() => this.updateAdventCalendarData(player));
		});

		print("AdventCalendarService initialized");
	}

	/**
	 * Generates the calendar key for storing in player data
	 */
	private getCalendarKey(): string {
		if (this.config === undefined) {
			return "";
		}
		const endDate = this.config.EndDate;
		return `${this.config.Name}_${endDate[0]}-${endDate[1]}-${endDate[2]}`;
	}

	/**
	 * Sets the advent calendar configuration
	 */
	public setConfig(config: AdventCalendarConfig): void {
		this.config = config;
	}

	/**
	 * Gets the current day of the advent calendar (1-based)
	 */
	public getCurrentDay(): number {
		if (this.config === undefined) {
			return 0;
		}

		const config = this.config;
		const now = os.time();

		// Create the target time for the first day
		const currentDayDate = os.time({
			year: config.StartDate[0],
			month: config.StartDate[1],
			day: config.StartDate[2],
			hour: config.TargetHour,
			min: config.TargetMin,
			sec: 0,
		});

		// If current time is before the first day, return 0
		if (now < currentDayDate) {
			return 0;
		}

		const firstDay = currentDayDate;
		const unixDifference = now - firstDay;
		const dayDifference = math.floor(unixDifference / 86400);

		return math.max(0, dayDifference + 1);
	}

	private getTotalDays(): number {
		if (this.config === undefined) {
			return 0;
		}
		const rewards = this.config.Rewards;
		let maxDay = 0;
		for (const [dayStr] of pairs(rewards)) {
			const day = tonumber(dayStr);
			if (day !== undefined && day > maxDay) {
				maxDay = day;
			}
		}
		return maxDay;
	}

	/**
	 * Checks if the advent calendar is currently active
	 */
	public isAdventCalendarActive(): boolean {
		if (this.config === undefined) {
			return false;
		}

		const currentDay = this.getCurrentDay();
		return currentDay >= 1 && currentDay <= this.getTotalDays();
	}

	/**
	 * Claims a reward for a specific day
	 */
	public async claimAdventReward(player: Player, day: number): Promise<boolean> {
		if (this.config === undefined) {
			return false;
		}

		const [canClaim, errorMessage] = await this.canClaimAdventReward(player, day);
		if (canClaim === false) {
			warn(`Cannot claim advent reward: ${errorMessage}`);
			return false;
		}

		const config = this.config;
		const reward = config.Rewards[day];
		if (reward === undefined) {
			return false;
		}

		const playerStore = this.dataService.getPlayerStore();

		try {
			let rewardClaimed = false;

			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			await playerStore.updateAsync(player, (playerData: any) => {
				const calendarKey = this.getCalendarKey();
				if (calendarKey === "") {
					return false;
				}

				// Initialize advent calendar data if it doesn't exist
				if (playerData.adventCalendar === undefined) {
					playerData.adventCalendar = {};
				}

				// Initialize this calendar if it doesn't exist
				if (playerData.adventCalendar[calendarKey] === undefined) {
					playerData.adventCalendar[calendarKey] = {
						claimed: [],
						onlineDays: 0,
					};
				}

				// Check if day is already claimed
				if (playerData.adventCalendar[calendarKey].claimed.includes(day) === true) {
					warn(`Player ${player.Name} already claimed advent reward for day ${day}`);
					return false;
				}

				// Mark day as claimed
				playerData.adventCalendar[calendarKey].claimed.push(day);

				// Give rewards
				this.giveAdventRewardDirect(playerData, reward);

				rewardClaimed = true;
				print(`${player.DisplayName} claimed advent calendar day ${day} reward!`);

				return true; // Commit changes
			});

			return rewardClaimed;
		} catch (error) {
			warn(`Failed to claim advent reward for player ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Gives advent calendar rewards directly to player data (for use within updateAsync)
	 */
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	private giveAdventRewardDirect(playerData: any, reward: Record<string, unknown>): void {
		const processRewardCategory = (category: unknown) => {
			if (category !== undefined && typeIs(category, "table")) {
				for (const [id, amount] of pairs(category as Record<string, unknown>)) {
					if (typeIs(amount, "number")) {
						let item = playerData.items.find((item: { id: string }) => item.id === id);
						if (item === undefined) {
							item = { id: id, uuid: `${id}-${os.time()}`, amount: 0, locked: false };
							playerData.items.push(item);
						}
						item.amount += amount;
					}
				}
			}
		};

		processRewardCategory(reward.Currencies);
		processRewardCategory(reward.Items);
	}

	/**
	 * Checks if a player can claim a reward for a specific day
	 */
	public async canClaimAdventReward(player: Player, day: number): Promise<[boolean, string?]> {
		if (this.config === undefined) {
			return [false, "Advent calendar not configured"];
		}

		const config = this.config;

		// Check if day is valid
		if (day < 1 || day > this.getTotalDays()) {
			return [false, "Invalid day"];
		}

		// Check if reward exists for this day
		if (config.Rewards[day] === undefined) {
			return [false, "No reward configured for this day"];
		}

		// Check if current day has reached or passed the target day
		const currentDay = this.getCurrentDay();
		if (currentDay < day) {
			return [false, "Day not yet unlocked"];
		}

		// Check if player has already claimed this day
		const playerStore = this.dataService.getPlayerStore();
		try {
			const playerData = await playerStore.getAsync(player);
			if (playerData !== undefined) {
				// eslint-disable-next-line @typescript-eslint/no-explicit-any
				const data = playerData as any;
				const calendarKey = this.getCalendarKey();
				if (data.adventCalendar?.[calendarKey]?.claimed?.includes(day) === true) {
					return [false, "Already claimed"];
				}
			}
		} catch (error) {
			warn(`Failed to check claim status for player ${player.Name}: ${error}`);
			return [false, "Failed to check claim status"];
		}

		return [true];
	}

	/**
	 * Gets claimed days for a player
	 */
	public async getClaimedDays(player: Player): Promise<number[]> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			const playerData = await playerStore.getAsync(player);
			if (playerData === undefined) {
				return [];
			}
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			const data = playerData as any;
			const calendarKey = this.getCalendarKey();
			return data.adventCalendar?.[calendarKey]?.claimed ?? [];
		} catch (error) {
			warn(`Failed to get claimed days for player ${player.Name}: ${error}`);
			return [];
		}
	}

	/**
	 * Gets online days for a player
	 */
	public async getOnlineDays(player: Player): Promise<number> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			const playerData = await playerStore.getAsync(player);
			if (playerData === undefined) {
				return 0;
			}
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			const data = playerData as any;
			const calendarKey = this.getCalendarKey();
			return data.adventCalendar?.[calendarKey]?.onlineDays ?? 0;
		} catch (error) {
			warn(`Failed to get online days for player ${player.Name}: ${error}`);
			return 0;
		}
	}

	/**
	 * Updates advent calendar data when a player joins
	 */
	public async updateAdventCalendarData(player: Player): Promise<void> {
		if (this.config === undefined) {
			return;
		}

		const playerStore = this.dataService.getPlayerStore();

		try {
			await playerStore.updateAsync(player, (playerData) => {
				// eslint-disable-next-line @typescript-eslint/no-explicit-any
				const data = playerData as any;
				const calendarKey = this.getCalendarKey();
				if (calendarKey === "") {
					return false;
				}

				// Initialize advent calendar data if it doesn't exist
				if (data.adventCalendar === undefined) {
					data.adventCalendar = {};
				}

				// Initialize this calendar if it doesn't exist
				if (data.adventCalendar[calendarKey] === undefined) {
					data.adventCalendar[calendarKey] = {
						onlineDays: 1,
						claimed: [],
					};
					return true; // Commit changes
				} else {
					// Increment online days (since player joined today)
					data.adventCalendar[calendarKey].onlineDays =
						(data.adventCalendar[calendarKey].onlineDays ?? 0) + 1;
					return true; // Commit changes
				}
			});
		} catch (error) {
			warn(`Failed to update advent calendar data for player ${player.Name}: ${error}`);
		}
	}

	/**
	 * Gets time until next day unlock (in seconds)
	 */
	public getTimeUntilNextDay(): number {
		if (this.config === undefined) {
			return 0;
		}

		const config = this.config;
		const now = os.time();

		// Calculate next unlock time
		const currentDay = this.getCurrentDay();
		const nextDay = currentDay + 1;

		const nextUnlockTime = os.time({
			year: config.StartDate[0],
			month: config.StartDate[1],
			day: config.StartDate[2] + nextDay - 1,
			hour: config.TargetHour,
			min: config.TargetMin,
			sec: 0,
		});

		return math.max(0, nextUnlockTime - now);
	}

	/**
	 * Gets all advent calendar data for a player
	 */
	public async getAllAdventCalendarData(
		player: Player,
	): Promise<Record<string, { claimed: number[]; onlineDays: number }>> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			const playerData = await playerStore.getAsync(player);
			if (playerData === undefined) {
				return {};
			}
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			const data = playerData as any;
			return data.adventCalendar ?? {};
		} catch (error) {
			warn(`Failed to get all advent calendar data for player ${player.Name}: ${error}`);
			return {};
		}
	}
}
