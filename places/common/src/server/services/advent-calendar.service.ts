import { Service, OnInit, Dependency } from "@flamework/core";
import { Players } from "@rbxts/services";
import LemonSignal from "@rbxts/lemon-signal";
import { DataService } from "@services/data.service";

const version = { major: 1, minor: 0, patch: 0 };

// Create signals for advent calendar events
const dayUnlockedEvent = new LemonSignal<{player: Player, day: number}>();
const rewardClaimedEvent = new LemonSignal<{player: Player, day: number, rewards: Record<string, unknown>}>();
const calendarEndedEvent = new LemonSignal<{player: Player}>();

export interface AdventCalendarConfig {
	startYear: number;
	startMonth: number;
	startDay: number;
	targetHour: number;
	targetMin: number;
	totalDays: number;
	rewards: { [day: number]: { [key: string]: unknown } }; // day -> rewards
}

/**
 * Advent calendar system for managing time-limited daily rewards during special events.
 */
@Service()
export class AdventCalendarService implements OnInit {
	public readonly version = version;

	// Events
	public readonly dayUnlocked = dayUnlockedEvent;
	public readonly rewardClaimed = rewardClaimedEvent;
	public readonly calendarEnded = calendarEndedEvent;

	// Configuration
	private config: AdventCalendarConfig | undefined = undefined;

	constructor(
		@Dependency private readonly dataService: DataService
	) {}

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
				3: { Gold: 1500, Gems: 15, Items: { "SpecialItem": 1 } },
				// Add more rewards as needed
			}
		});

		// Connect to player events
		Players.PlayerAdded.Connect((player) => {
			this.updateAdventCalendarData(player);
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
	 * Gets the current configuration
	 */
	public getConfig(): AdventCalendarConfig | undefined {
		return this.config;
	}

	/**
	 * Gets the first day of the advent calendar as a timestamp.
	 */
	private getFirstDay(): number {
		if (!this.config) {
			error("Advent calendar config not loaded");
		}

		const config = this.config;
		return os.time({
			year: config.startYear,
			month: config.startMonth,
			day: config.startDay,
			hour: config.targetHour,
			min: config.targetMin,
			sec: 0
		});
	}

	/**
	 * Gets the current day number in the advent calendar.
	 */
	public getCurrentDay(): number {
		if (!this.config) {
			return 0;
		}

		const config = this.config;
		const currentTime = os.time();
		let currentDayDate = os.time({
			year: os.date("*t").year,
			month: os.date("*t").month,
			day: os.date("*t").day,
			hour: config.targetHour,
			min: config.targetMin,
			sec: 0
		});

		// If we haven't reached today's target time, use yesterday
		if (currentTime < currentDayDate) {
			currentDayDate -= 86400; // Subtract one day
		}

		const firstDay = this.getFirstDay();
		const unixDifference = currentDayDate - firstDay;
		const dayDifference = math.floor(unixDifference / 86400);

		return math.max(0, dayDifference);
	}

	/**
	 * Gives advent calendar rewards to a player
	 */
	public async giveAdventReward(player: Player, reward: Record<string, unknown>): Promise<void> {
		const dataDocument = await this.dataService.getPlayerDataDocument(player);
		if (!dataDocument) {
			warn(`Failed to get data document for player ${player.Name}`);
			return;
		}

		const data = dataDocument.read();
		const newData = { ...data };

		// Add currencies
		if (reward.Gold) {
			newData.Currencies.Gold = (newData.Currencies.Gold || 0) + (reward.Gold as number);
		}
		if (reward.Gems) {
			newData.Currencies.Gems = (newData.Currencies.Gems || 0) + (reward.Gems as number);
		}

		// Add items
		if (reward.Items) {
			const items = reward.Items as Record<string, number>;
			for (const [itemId, count] of pairs(items)) {
				if (!newData.Inventory.Items[itemId]) {
					newData.Inventory.Items[itemId] = { Count: 0 };
				}
				newData.Inventory.Items[itemId].Count += count;
			}
		}

		dataDocument.write(newData);
	}

	/**
	 * Claims an advent reward for a specific day
	 */
	public async claimAdventReward(player: Player, day: number): Promise<boolean> {
		if (!this.config) {
			warn("Advent calendar not configured");
			return false;
		}

		const [canClaim, reason] = await this.canClaimAdventReward(player, day);
		if (!canClaim) {
			warn(`Cannot claim advent reward for day ${day}: ${reason}`);
			return false;
		}

		const dataDocument = await this.dataService.getPlayerDataDocument(player);
		if (!dataDocument) {
			warn(`Failed to get data document for player ${player.Name}`);
			return false;
		}

		const data = dataDocument.read();
		const newData = { ...data };

		// Mark day as claimed
		if (!newData.AdventCalendarData.Claimed) {
			newData.AdventCalendarData.Claimed = [];
		}
		newData.AdventCalendarData.Claimed.push(day);

		// Give rewards
		const reward = this.config.rewards[day];
		if (reward) {
			await this.giveAdventReward(player, reward);
		}

		dataDocument.write(newData);

		// Fire event
		this.rewardClaimed.fire({ player, day, rewards: reward || {} });

		return true;
	}

	/**
	 * Updates advent calendar data when player joins
	 */
	public async updateAdventCalendarData(player: Player): Promise<void> {
		if (!this.config) {
			return;
		}

		const dataDocument = await this.dataService.getPlayerDataDocument(player);
		if (!dataDocument) {
			warn(`Failed to get data document for player ${player.Name}`);
			return;
		}

		const data = dataDocument.read();
		const newData = { ...data };

		// Initialize advent calendar data if not exists
		if (!newData.AdventCalendarData) {
			newData.AdventCalendarData = {
				OnlineDays: 0,
				DayNumber: 0,
				Claimed: []
			};
		}

		const currentDay = this.getCurrentDay();
		const lastDayNumber = newData.AdventCalendarData.DayNumber || 0;

		// Check if it's a new day
		if (currentDay > lastDayNumber) {
			newData.AdventCalendarData.OnlineDays = (newData.AdventCalendarData.OnlineDays || 0) + 1;
			newData.AdventCalendarData.DayNumber = currentDay;

			// Fire day unlocked event
			this.dayUnlocked.fire({ player, day: currentDay });
		}

		dataDocument.write(newData);
	}

	/**
	 * Checks if a player can claim a reward for a specific day
	 */
	public async canClaimAdventReward(player: Player, day: number): Promise<[boolean, string?]> {
		if (!this.config) {
			return [false, "Advent calendar not configured"];
		}

		if (day < 1 || day > this.config.totalDays) {
			return [false, "Invalid day"];
		}

		if (!this.config.rewards[day]) {
			return [false, "No reward configured for this day"];
		}

		if (!this.isAdventCalendarActive()) {
			return [false, "Advent calendar is not active"];
		}

		const dataDocument = await this.dataService.getPlayerDataDocument(player);
		if (!dataDocument) {
			return [false, "Failed to load player data"];
		}

		const data = dataDocument.read();
		const adventData = data.AdventCalendarData;

		if (!adventData) {
			return [false, "Advent calendar data not initialized"];
		}

		// Check if already claimed
		if (adventData.Claimed && adventData.Claimed.includes(day)) {
			return [false, "Already claimed"];
		}

		// Check if day is unlocked (player has been online enough days)
		const onlineDays = adventData.OnlineDays || 0;
		if (onlineDays < day) {
			return [false, "Must be online for more days"];
		}

		return [true];
	}

	/**
	 * Gets the days a player has claimed rewards for
	 */
	public async getClaimedDays(player: Player): Promise<number[]> {
		const dataDocument = await this.dataService.getPlayerDataDocument(player);
		if (!dataDocument) {
			return [];
		}

		const data = dataDocument.read();
		return data.AdventCalendarData?.Claimed || [];
	}

	/**
	 * Gets the number of online days for a player
	 */
	public async getOnlineDays(player: Player): Promise<number> {
		const dataDocument = await this.dataService.getPlayerDataDocument(player);
		if (!dataDocument) {
			return 0;
		}

		const data = dataDocument.read();
		return data.AdventCalendarData?.OnlineDays || 0;
	}

	/**
	 * Checks if the advent calendar is currently active
	 */
	public isAdventCalendarActive(): boolean {
		if (!this.config) {
			return false;
		}

		const currentTime = os.time();
		const startTime = this.getFirstDay();
		const endTime = startTime + (this.config.totalDays * 86400); // Add total days in seconds

		return currentTime >= startTime && currentTime <= endTime;
	}

	/**
	 * Gets the time until the next day unlocks
	 */
	public getTimeUntilNextDay(): number {
		if (!this.config) {
			return 0;
		}

		const now = os.time();
		const todayDate = os.date("*t");
		
		const nextUnlockTime = os.time({
			year: todayDate.year,
			month: todayDate.month,
			day: todayDate.day + 1,
			hour: this.config.targetHour,
			min: this.config.targetMin,
			sec: 0
		});

		return math.max(0, nextUnlockTime - now);
	}
}
