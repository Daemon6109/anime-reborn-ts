import { Service, OnInit } from "@flamework/core";
import { Players } from "@rbxts/services";
import { DataService } from "./data.service";
import { safePlayerAdded } from "../../shared/utils/safe-player-added.util";

const version = { major: 1, minor: 0, patch: 0 };

export interface AdventCalendarConfig {
	startYear: number;
	startMonth: number;
	startDay: number;
	targetHour: number;
	targetMin: number;
	totalDays: number;
	rewards: { [day: number]: { [key: string]: unknown } };
}

/**
 * Advent calendar system for managing time-limited daily rewards during special events.
 */
@Service()
export class AdventCalendarService implements OnInit {
	public readonly version = version;

	// Configuration
	private config: AdventCalendarConfig | undefined = undefined;

	constructor(private readonly dataService: DataService) {}

	public onInit(): void {
		// Initialize with default config for winter event
		this.setConfig({
			startYear: 2024,
			startMonth: 12,
			startDay: 1,
			targetHour: 0,
			targetMin: 0,
			totalDays: 25,
			rewards: {
				1: { Gold: 1000, Gems: 10 },
				2: { Gold: 1200, Gems: 12 },
				3: { Gold: 1500, Gems: 15, Items: { SpecialItem: 1 } },
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
	 * Sets the advent calendar configuration
	 */
	public setConfig(config: AdventCalendarConfig): void {
		this.config = config;
	}

	/**
	 * Gets the current day of the advent calendar (1-based)
	 */
	public getCurrentDay(): number {
		if (!this.config) {
			return 0;
		}

		const config = this.config;
		const now = os.time();

		// Create the target time for the first day
		const currentDayDate = os.time({
			year: config.startYear,
			month: config.startMonth,
			day: config.startDay,
			hour: config.targetHour,
			min: config.targetMin,
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

	/**
	 * Checks if the advent calendar is currently active
	 */
	public isAdventCalendarActive(): boolean {
		if (!this.config) {
			return false;
		}

		const currentDay = this.getCurrentDay();
		return currentDay >= 1 && currentDay <= this.config.totalDays;
	}

	/**
	 * Claims a reward for a specific day
	 */
	public async claimAdventReward(player: Player, day: number): Promise<boolean> {
		if (!this.config) {
			return false;
		}

		const [canClaim, errorMessage] = this.canClaimAdventReward(player, day);
		if (!canClaim) {
			warn(`Cannot claim advent reward: ${errorMessage}`);
			return false;
		}

		const config = this.config;
		const reward = config.rewards[day];
		if (!reward) {
			return false;
		}

		// Get player data
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return false;
		}

		const newData = { ...playerData };

		// Mark day as claimed
		if (!newData.AdventCalendarData) {
			newData.AdventCalendarData = {
				Name: "AdventCalendar",
				DayNumber: 0,
				OnlineDays: 0,
				Claimed: [],
			};
		}
		if (!newData.AdventCalendarData.Claimed) {
			newData.AdventCalendarData.Claimed = [];
		}

		newData.AdventCalendarData.Claimed.push(day);

		// Give rewards
		await this.giveAdventReward(player, reward);

		this.dataService.setCache(player, newData);
		return true;
	}

	/**
	 * Gives advent calendar rewards to a player
	 */
	public async giveAdventReward(player: Player, reward: Record<string, unknown>): Promise<void> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get data for player ${player.Name}`);
			return;
		}

		const newData = { ...playerData };

		// Add currencies
		if (reward.Gold !== undefined && typeIs(reward.Gold, "number")) {
			newData.Currencies.Gold = (newData.Currencies.Gold ?? 0) + reward.Gold;
		}
		if (reward.Gems !== undefined && typeIs(reward.Gems, "number")) {
			newData.Currencies.Gems = (newData.Currencies.Gems ?? 0) + reward.Gems;
		}

		// Add items
		if (reward.Items !== undefined && typeIs(reward.Items, "table")) {
			for (const [itemId, amount] of pairs(reward.Items as Record<string, unknown>)) {
				if (typeIs(amount, "number")) {
					if (!newData.Inventory.Items[itemId]) {
						newData.Inventory.Items[itemId] = { Count: 0, Cost: 0 };
					}
					newData.Inventory.Items[itemId].Count += amount;
				}
			}
		}

		this.dataService.setCache(player, newData);
	}

	/**
	 * Checks if a player can claim a reward for a specific day
	 */
	public canClaimAdventReward(player: Player, day: number): [boolean, string?] {
		if (!this.config) {
			return [false, "Advent calendar not configured"];
		}

		const config = this.config;

		// Check if day is valid
		if (day < 1 || day > config.totalDays) {
			return [false, "Invalid day"];
		}

		// Check if reward exists for this day
		if (!config.rewards[day]) {
			return [false, "No reward configured for this day"];
		}

		// Check if current day has reached or passed the target day
		const currentDay = this.getCurrentDay();
		if (currentDay < day) {
			return [false, "Day not yet unlocked"];
		}

		return [true];
	}

	/**
	 * Gets claimed days for a player
	 */
	public async getClaimedDays(player: Player): Promise<number[]> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return [];
		}
		return playerData.AdventCalendarData?.Claimed ?? [];
	}

	/**
	 * Gets online days for a player
	 */
	public async getOnlineDays(player: Player): Promise<number> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return 0;
		}
		return playerData.AdventCalendarData?.OnlineDays ?? 0;
	}

	/**
	 * Updates advent calendar data when a player joins
	 */
	public async updateAdventCalendarData(player: Player): Promise<void> {
		if (!this.config) {
			return;
		}

		const currentDay = this.getCurrentDay();
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return;
		}

		const newData = { ...playerData };

		if (!newData.AdventCalendarData) {
			newData.AdventCalendarData = {
				Name: "AdventCalendar",
				DayNumber: currentDay,
				OnlineDays: 1,
				Claimed: [],
			};
		} else {
			const lastDayNumber = newData.AdventCalendarData.DayNumber ?? 0;

			// If this is a new day, increment online days
			if (currentDay > lastDayNumber) {
				newData.AdventCalendarData.OnlineDays = (newData.AdventCalendarData.OnlineDays ?? 0) + 1;
				newData.AdventCalendarData.DayNumber = currentDay;
			}
		}

		this.dataService.setCache(player, newData);
	}

	/**
	 * Gets time until next day unlock (in seconds)
	 */
	public getTimeUntilNextDay(): number {
		if (!this.config) {
			return 0;
		}

		const config = this.config;
		const now = os.time();

		// Calculate next unlock time
		const currentDay = this.getCurrentDay();
		const nextDay = currentDay + 1;

		const nextUnlockTime = os.time({
			year: config.startYear,
			month: config.startMonth,
			day: config.startDay + nextDay - 1,
			hour: config.targetHour,
			min: config.targetMin,
			sec: 0,
		});

		return math.max(0, nextUnlockTime - now);
	}
}
