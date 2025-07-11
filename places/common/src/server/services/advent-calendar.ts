import { Service, OnInit } from "@flamework/core";
import { DataStore } from "@server/services/player-data";
import { safePlayerAdded } from "@shared/utils/safe-player-added.util";
import { adventCalendarData, CalendarName, AdventCalendarData } from "@shared/data/advent-calendar-data";
import { Analytics } from "@server/services/analytics";
import type { PlayerData } from "@shared/atoms/player-data";

const version = { major: 1, minor: 0, patch: 0 };

// Player item type definition
interface PlayerItem {
	id: string;
	uuid: string;
	amount: number;
	locked: boolean;
}

export type ExactConfiguration<T extends CalendarName> = (typeof adventCalendarData)[T];

/**
 * Advent calendar system for managing time-limited daily rewards during special events.
 */
@Service()
export class AdventCalendarService implements OnInit {
	public readonly version = version;

	// Current active calendar name
	private activeCalendarName?: CalendarName = undefined;

	constructor(
		private readonly dataService: DataStore,
		private readonly analytics: Analytics,
	) {}

	public onInit(): void {
		// Set the active calendar (you can change this to switch between calendars)
		this.setActiveCalendar("Christmas_1");

		// Handle player joining to update advent calendar data
		safePlayerAdded((player) => {
			this.updateAdventCalendarData(player);
		});

		print("AdventCalendarService initialized");
	}

	/**
	 * Sets the active advent calendar by name
	 */
	public setActiveCalendar(calendarName: CalendarName): void {
		if (adventCalendarData[calendarName] !== undefined) {
			this.activeCalendarName = calendarName;
			print(`Active advent calendar set to: ${calendarName}`);
		} else {
			warn(`Calendar '${calendarName}' not found in configuration`);
		}
	}

	/**
	 * Gets the current active calendar configuration
	 */
	private getActiveConfig(): ExactConfiguration<CalendarName> | undefined {
		if (this.activeCalendarName === undefined) {
			return undefined;
		}
		return adventCalendarData[this.activeCalendarName as CalendarName];
	}

	/**
	 * Generates the calendar key for storing in player data
	 */
	private getCalendarKey(): CalendarName {
		assert(this.activeCalendarName);
		// For now, we'll use just the calendar name as key since EndDate is not in the JSON
		// You might want to add EndDate to the JSON later for better key generation
		return this.activeCalendarName;
	}

	/**
	 * Gets the current day of the advent calendar (1-based)
	 */
	public getCurrentDay(): number {
		const config = this.getActiveConfig();
		if (config === undefined) {
			return 0;
		}

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
		const config = this.getActiveConfig();
		if (config === undefined) {
			return 0;
		}
		const rewards = config.Rewards;
		let maxDay = 0;
		for (const [dayStr] of pairs(rewards as unknown as Record<string, unknown>)) {
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
		const config = this.getActiveConfig();
		if (config === undefined) {
			return false;
		}

		const currentDay = this.getCurrentDay();
		return currentDay >= 1 && currentDay <= this.getTotalDays();
	}

	/**
	 * Claims a reward for a specific day
	 */
	public async claimAdventReward(player: Player, day: number): Promise<boolean> {
		const config = this.getActiveConfig();
		if (config === undefined) {
			return false;
		}

		const [canClaim, errorMessage] = await this.canClaimAdventReward(player, day);
		if (canClaim === false) {
			// Log failed claim attempt
			this.analytics.LogCustomEvent(player, "advent_calendar_claim_failed", 1, {
				calendar_name: this.activeCalendarName ?? "Unknown",
				day: tostring(day),
				reason: errorMessage ?? "Unknown",
			});
			warn(`Cannot claim advent reward: ${errorMessage}`);
			return false;
		}

		const reward = (config.Rewards as Record<string, unknown>)[tostring(day)] as
			| Record<string, unknown>
			| undefined;
		if (reward === undefined) {
			return false;
		}

		const playerStore = this.dataService.getPlayerStore();

		try {
			let rewardClaimed = false;

			await playerStore.updateAsync(player, (playerData) => {
				const calendarKey = this.getCalendarKey();

				// Initialize advent calendar data if it doesn't exist
				if (playerData.adventCalendar === undefined) {
					playerData.adventCalendar = new Map();
				}

				// Initialize this calendar if it doesn't exist
				if (playerData.adventCalendar.get(calendarKey) === undefined) {
					playerData.adventCalendar.set(calendarKey, {
						claimed: [],
						onlineDays: 0,
					});
				}

				// Check if day is already claimed
				const calendarEntry = playerData.adventCalendar.get(calendarKey)!;
				if (calendarEntry.claimed.includes(day) === true) {
					warn(`Player ${player.Name} already claimed advent reward for day ${day}`);
					return false;
				}

				// Mark day as claimed
				calendarEntry.claimed.push(day);

				// Give rewards
				this.giveAdventRewardDirect(playerData, reward);

				rewardClaimed = true;
				print(`${player.DisplayName} claimed advent calendar day ${day} reward!`);

				// Log analytics after successful claim
				this.logRewardClaimAnalytics(player, day, reward);

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
	private giveAdventRewardDirect(playerData: PlayerData, reward: Record<string, unknown>): void {
		const processRewardCategory = (category: unknown) => {
			if (category !== undefined && typeIs(category, "table")) {
				for (const [id, amount] of pairs(category as Record<string, unknown>)) {
					if (typeIs(amount, "number")) {
						let item = playerData.items.find((item: PlayerItem) => item.id === id);
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
		const config = this.getActiveConfig();
		if (config === undefined) {
			return [false, "Advent calendar not configured"];
		}

		// Check if day is valid
		if (day < 1 || day > this.getTotalDays()) {
			return [false, "Invalid day"];
		}

		// Check if reward exists for this day
		if ((config.Rewards as Record<string, unknown>)[tostring(day)] === undefined) {
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
				const data = playerData;
				const calendarKey = this.getCalendarKey();
				if (data.adventCalendar?.get(calendarKey)?.claimed?.includes(day) === true) {
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
			const data = playerData;
			const calendarKey = this.getCalendarKey();
			return data.adventCalendar?.get(calendarKey)?.claimed ?? [];
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
			const data = playerData;
			const calendarKey = this.getCalendarKey();
			return data.adventCalendar?.get(calendarKey)?.onlineDays ?? 0;
		} catch (error) {
			warn(`Failed to get online days for player ${player.Name}: ${error}`);
			return 0;
		}
	}

	/**
	 * Updates advent calendar data when a player joins
	 */
	public async updateAdventCalendarData(player: Player): Promise<void> {
		const config = this.getActiveConfig();
		if (config === undefined) {
			return;
		}

		const playerStore = this.dataService.getPlayerStore();

		try {
			let isFirstTime = false;

			await playerStore.updateAsync(player, (playerData) => {
				const data = playerData;
				const calendarKey = this.getCalendarKey();

				// Initialize advent calendar data if it doesn't exist
				if (data.adventCalendar === undefined) {
					data.adventCalendar = new Map();
				}

				// Initialize this calendar if it doesn't exist
				if (data.adventCalendar.get(calendarKey) === undefined) {
					data.adventCalendar.set(calendarKey, {
						onlineDays: 1,
						claimed: [],
					});
					isFirstTime = true;
					return true; // Commit changes
				} else {
					// Increment online days (since player joined today)
					const calendarEntry = data.adventCalendar.get(calendarKey)!;
					calendarEntry.onlineDays = (calendarEntry.onlineDays ?? 0) + 1;
					return true; // Commit changes
				}
			});

			// Log analytics after successful update
			this.logCalendarParticipationAnalytics(player, isFirstTime);
		} catch (error) {
			warn(`Failed to update advent calendar data for player ${player.Name}: ${error}`);
		}
	}

	/**
	 * Gets time until next day unlock (in seconds)
	 */
	public getTimeUntilNextDay(): number {
		const config = this.getActiveConfig();
		if (config === undefined) {
			return 0;
		}

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
	public async getAllAdventCalendarData(player: Player): Promise<AdventCalendarData> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			const playerData = await playerStore.getAsync(player);
			if (playerData === undefined) {
				return new Map();
			}
			const data = playerData;
			return data.adventCalendar ?? new Map();
		} catch (error) {
			warn(`Failed to get all advent calendar data for player ${player.Name}: ${error}`);
			return new Map();
		}
	}

	/**
	 * Logs analytics for reward claim events
	 */
	private logRewardClaimAnalytics(player: Player, day: number, reward: Record<string, unknown>): void {
		const calendarName = this.activeCalendarName ?? "Unknown";

		// Log custom event for reward claim
		this.analytics.LogCustomEvent(player, "advent_calendar_reward_claimed", 1, {
			calendar_name: calendarName,
			day: tostring(day),
			reward_type: this.getRewardTypeFromReward(reward),
		});

		// Log progression event
		this.analytics.LogProgressionEvent(
			player,
			`advent_calendar_${calendarName}`,
			Enum.AnalyticsProgressionType.Complete,
			day,
			`Day ${day}`,
			{
				calendar_name: calendarName,
				total_days: tostring(this.getTotalDays()),
			},
		);

		// Log economy events for currency rewards
		this.logEconomyEventsForReward(player, reward);
	}

	/**
	 * Logs economy events for currency rewards
	 */
	private logEconomyEventsForReward(player: Player, reward: Record<string, unknown>): void {
		const currencies = reward.Currencies as Record<string, number> | undefined;
		if (currencies !== undefined && typeIs(currencies, "table")) {
			for (const [currencyId, amount] of pairs(currencies)) {
				if (typeIs(amount, "number") && amount > 0) {
					// Map currency IDs to analytics-friendly names
					const currencyType = this.mapCurrencyIdToAnalyticsType(currencyId);
					if (currencyType !== undefined) {
						this.analytics.LogEconomyEvent(
							player,
							Enum.AnalyticsEconomyFlowType.Source,
							currencyType,
							amount,
							0, // We don't track ending balance here
							"TimedReward",
							undefined,
							{
								calendar_name: this.activeCalendarName ?? "Unknown",
								source: "advent_calendar",
							},
						);
					}
				}
			}
		}
	}

	/**
	 * Maps currency IDs to analytics currency types
	 */
	private mapCurrencyIdToAnalyticsType(currencyId: string): "Gold" | "Gems" | undefined {
		switch (currencyId) {
			case "Gold":
				return "Gold";
			case "Gems":
				return "Gems";
			default:
				return undefined; // Other currencies not tracked in economy events
		}
	}

	/**
	 * Gets reward type string from reward object
	 */
	private getRewardTypeFromReward(reward: Record<string, unknown>): string {
		const types: string[] = [];

		if (reward.Currencies !== undefined) {
			types.push("Currency");
		}
		if (reward.Items !== undefined) {
			types.push("Items");
		}

		return types.size() > 0 ? types.join(",") : "Unknown";
	}

	/**
	 * Logs analytics for calendar participation
	 */
	private logCalendarParticipationAnalytics(player: Player, isFirstTime: boolean): void {
		const calendarName = this.activeCalendarName ?? "Unknown";

		if (isFirstTime) {
			// Log funnel step for first-time participation
			this.analytics.LogFunnelStepEvent(
				player,
				"advent_calendar_onboarding",
				`${player.UserId}_${calendarName}`,
				1,
				"first_login",
				{
					calendar_name: calendarName,
				},
			);
		}

		// Log custom event for daily participation
		this.analytics.LogCustomEvent(player, "advent_calendar_daily_login", 1, {
			calendar_name: calendarName,
			is_first_time: tostring(isFirstTime),
		});
	}
}
