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
	 * Gets the first day of the advent calendar as a date object.
	 */
	private getFirstDay(): DateTime {
	//   @return Date -- The first day date object
	//
	//   ```ts
	//   const firstDay = AdventCalendar.getFirstDay();
	//   print(`First Advent Calendar Day: ${firstDay.getFullYear()}-${firstDay.getMonth() + 1}-${firstDay.getDate()} ${firstDay.getHours()}:${firstDay.getMinutes()}:${firstDay.getSeconds()}`);
	//   ```
	//]=]
	getFirstDay(): Date {
		if (!AdventCalendar.config) {
			error("Advent calendar config not loaded");
		}

		const config = AdventCalendar.config;
		return new Date(config.startYear, config.startMonth - 1, config.startDay, config.targetHour, config.targetMin, 0);
	},

	//[=[
	//   Gets the current day number in the advent calendar.
	//
	//   @within AdventCalendar
	//
	//   @return number -- The current day number (0 if before start)
	//
	//   ```ts
	//   const currentDay = AdventCalendar.getCurrentDay();
	//   print(`Current Advent Calendar Day: ${currentDay}`);
	//   ```
	//]=]
	getCurrentDay(): number {
		if (!AdventCalendar.config) {
			return 0;
		}

		const config = AdventCalendar.config;
		const now = new Date();
		
		let currentDayDate = new Date(now.getFullYear(), now.getMonth(), now.getDate(), config.targetHour, config.targetMin, 0);

		if (now.getHours() * 60 + now.getMinutes() < config.targetHour * 60 + config.targetMin) {
			currentDayDate.setDate(currentDayDate.getDate() -1);
		}
		
		const firstDay = AdventCalendar.getFirstDay();
		const unixDifference = (currentDayDate.getTime() - firstDay.getTime()) / 1000; //DateTime.fromUnixTimestamp is not a function

		const dayDifference = Math.floor(unixDifference / 86400);

		return Math.max(0, dayDifference);
	},

	//[=[
	//   Gives advent calendar rewards to a player.
	//
	//   @within AdventCalendar
	//
	//   @private
	//
	//   @param person Person -- The person to give rewards to
	//   @param reward { [key: string]: any } -- The reward data
	//
	//   ```ts
	//   AdventCalendar.giveAdventReward(player, { Gold: 100, Gems: 10 });
	//   ```
	//]=]
	giveAdventReward(person: Person, reward: { [key: string]: any }): void {
		person.dataCache((dataCache) => {
			const newDataCache = { ...dataCache };
			const currencies = newDataCache.Currencies;
			const inventory = newDataCache.Inventory.Items;

			// Give currency rewards
			for (const [rewardType, amount] of pairs(reward)) {
				if (typeIs(amount, "number")) {
					currencies[rewardType] = (currencies[rewardType] || 0) + amount;
				} else if (typeIs(amount, "string")) {
					// Special item reward
					inventory[amount] = inventory[amount] || { Count: 0 };
					inventory[amount].Count = inventory[amount].Count + 1;
				}
			}

			return newDataCache;
		});
	},

	//[=[
	//   Claims an advent calendar reward for a player.
	//
	//   @within AdventCalendar
	//
	//   @param person Person -- The person claiming the reward
	//   @param day number -- The day to claim
	//
	//   @return boolean -- Whether the claim was successful
	//
	//   ```ts
	//   const success = AdventCalendar.claimAdventReward(player, 1);
	//   if (success) {
	// 	   print("Reward claimed successfully!");
	//   } else {
	// 	   print("Failed to claim reward.");
	//   }
	//   ```
	//]=]
	claimAdventReward(person: Person, day: number): boolean {
		const [canClaim, errorMessage] = AdventCalendar.canClaimAdventReward(person, day);
		if (!canClaim) {
			warn(`Cannot claim advent reward: ${errorMessage}`);
			return false;
		}

		const config = AdventCalendar.config;
		assert(config, "Advent calendar config not set");
		const reward = config.rewards[day];

		// Give rewards
		AdventCalendar.giveAdventReward(person, reward);

		// Mark as claimed
		person.dataCache((dataCache) => {
			const newDataCache = { ...dataCache };
			const acData = newDataCache.AdventCalendarData;

			const claimed = acData.Claimed || [];
			claimed.push(day);
			acData.Claimed = claimed;

			return newDataCache;
		});

		rewardClaimedEvent.fire(person.player, day);
		return true;
	},

	//[=[
	//   Updates advent calendar data for a player.
	//
	//   @within AdventCalendar
	//
	//   @private
	//
	//   @param person Person -- The person to update data for
	//
	//   ```ts
	//   AdventCalendar.updateAdventCalendarData(player);
	//   ```
	//]=]
	updateAdventCalendarData(person: Person): void {
		if (!AdventCalendar.config) {
			return;
		}

		const currentDay = AdventCalendar.getCurrentDay();

		person.dataCache((dataCache) => {
			const newDataCache = { ...dataCache };
			const acData = newDataCache.AdventCalendarData;

			// Initialize if needed
			if (!acData.OnlineDays) {
				acData.OnlineDays = 0;
			}

			if (!acData.DayNumber) {
				acData.DayNumber = 0;
			}

			if (!acData.Claimed) {
				acData.Claimed = [];
			}

			// Check if it's a new day
			if (acData.DayNumber !== currentDay) {
				acData.DayNumber = currentDay;
				acData.OnlineDays = acData.OnlineDays + 1;

				// Unlock new day
				if (currentDay > 0 && currentDay <= AdventCalendar.config!.totalDays) {
					dayUnlockedEvent.fire(person.player, currentDay);
				}
			}

			return newDataCache;
		});
	},

	//[=[
	//   Checks if a player can claim a reward for a specific day.
	//
	//   @within AdventCalendar
	//
	//   @param person Person -- The person to check
	//   @param day number -- The day to check
	//
	//   @return [boolean, string?] -- Whether the reward can be claimed and an optional error message
	//
	//   ```ts
	//   const [canClaim, errorMessage] = AdventCalendar.canClaimAdventReward(player, 1);
	//   if (canClaim) {
	// 	   print("You can claim the reward!");
	//   } else {
	// 	   print(`Cannot claim reward: ${errorMessage}`);
	//   }
	//   ```
	//]=]
	canClaimAdventReward(person: Person, day: number): [boolean, string?] {
		if (!AdventCalendar.config) {
			return [false, "Advent calendar not active"];
		}

		const config = AdventCalendar.config;

		// Check if day is valid
		if (day < 1 || day > config.totalDays) {
			return [false, "Invalid day"];
		}

		// Check if reward exists for this day
		if (!config.rewards[day]) {
			return [false, "No reward for this day"];
		}

		const dataCache = person.dataCache();
		const acData = dataCache.AdventCalendarData;

		// Check if already claimed
		if (acData.Claimed?.includes(day)) {
			return [false, "Already claimed"];
		}

		// Check if day is unlocked (player must have been online for this day)
		const currentDay = AdventCalendar.getCurrentDay();
		if (day > currentDay) {
			return [false, "Day not yet unlocked"];
		}

		// Check if player was online for enough days
		if ((acData.OnlineDays || 0) < day) {
			return [false, "Must be online for more days"];
		}

		return [true, undefined];
	},

	//[=[
	//   Gets the claimed days for a player.
	//
	//   @within AdventCalendar
	//
	//   @param person Person -- The person to check
	//
	//   @return number[] -- Array of claimed day numbers
	//
	//   ```ts
	//   const claimedDays = AdventCalendar.getClaimedDays(player);
	//   print(`Claimed Days: ${claimedDays.join(", ")}`);
	//   ```
	//]=]
	getClaimedDays(person: Person): number[] {
		const dataCache = person.dataCache();
		return dataCache.AdventCalendarData.Claimed || [];
	},

	//[=[
	//   Gets the number of days a player has been online during the event.
	//
	//   @within AdventCalendar
	//
	//   @param person Person -- The person to check
	//
	//   @return number -- Number of online days
	//
	//   ```ts
	//   const onlineDays = AdventCalendar.getOnlineDays(player);
	//   print(`Online Days: ${onlineDays}`);
	//   ```
	//]=]
	getOnlineDays(person: Person): number {
		const dataCache = person.dataCache();
		return dataCache.AdventCalendarData.OnlineDays || 0;
	},

	//[=[
	//   Checks if the advent calendar is currently active.
	//
	//   @within AdventCalendar
	//
	//   @return boolean -- Whether the calendar is active
	//
	//   ```ts
	//   const isActive = AdventCalendar.isAdventCalendarActive();
	//   if (isActive) {
	// 	   print("Advent calendar is active!");
	//   } else {
	// 	   print("Advent calendar is not active.");
	//   }
	//   ```
	//]=]
	isAdventCalendarActive(): boolean {
		if (!AdventCalendar.config) {
			return false;
		}

		const currentDay = AdventCalendar.getCurrentDay();
		return currentDay >= 1 && currentDay <= AdventCalendar.config.totalDays;
	},

	//[=[
	//   Gets the time remaining until the next day unlocks.
	//
	//   @within AdventCalendar
	//
	//   @return number -- Seconds until next day unlock
	//
	//   ```ts
	//   const timeUntilNextDay = AdventCalendar.getTimeUntilNextDay();
	//   print(`Time until next day unlocks: ${timeUntilNextDay} seconds`);
	//   ```
	//]=]
	getTimeUntilNextDay(): number {
		if (!AdventCalendar.config) {
			return 0;
		}

		const config = AdventCalendar.config;
		const now = new Date();

		// Calculate next unlock time
		const nextUnlockTime = new Date(
			now.getFullYear(),
			now.getMonth(),
			now.getDate() + 1,
			config.targetHour,
			config.targetMin,
			0
		);
		
		return Math.max(0, (nextUnlockTime.getTime() - now.getTime())/1000);
	},

	//[=[
	//   Sets a custom advent calendar configuration.
	//
	//   @within AdventCalendar
	//
	//   @param config AdventCalendarConfig -- The new configuration
	//
	//   ```ts
	//   AdventCalendar.setAdventCalendarConfig({
	// 	   startYear: 2024,
	// 	   startMonth: 12,
	// 	   startDay: 1,
	// 	   targetHour: 18,
	// 	   targetMin: 0,
	// 	   totalDays: 25,
	// 	   rewards: {
	// 		   1: { Gold: 100, Gems: 10 },
	// 		   2: { Gold: 150, Gems: 15 },
	// 		   // Add more rewards...
	// 	   },
	//   });
	//   ```
	//]=]
	setAdventCalendarConfig(config: AdventCalendarConfig): void {
		AdventCalendar.config = config;
	},
};

//[=[
//   Loads the default advent calendar configuration.
//
//   @within AdventCalendar
//
//   @private
//
//   ```ts
//   loadDefaultConfig();
//   ```
//]=]
function loadDefaultConfig(): void {
	// Example configuration - this would typically be loaded from a registry
	AdventCalendar.config = {
		startYear: 2024,
		startMonth: 12,
		startDay: 1,
		targetHour: 18, // 6 PM
		targetMin: 0,
		totalDays: 25, // 25 days for December
		rewards: {
			1: { Gold: 100, Gems: 10 },
			2: { Gold: 150, Gems: 15 },
			3: { Gold: 200, Gems: 20 },
			4: { Gold: 250, Gems: 25 },
			5: { Gold: 300, Gems: 30 },
			// Continue for all 25 days...
			25: { Gold: 2500, Gems: 250, SpecialItem: "ChristmasUnit" },
		},
	};
}


//[=[
//   This function is used to start the provider and initialize any necessary systems.
//
//   ```ts
//   start();
//   ```
//]=]
function start(): void {
	assert(AdventCalendar.config, "Advent calendar config not set. Call `setAdventCalendarConfig` before starting.");

	// Set up Blink network event handling
	Network.ClaimAdventReward.on(async (player, day) => {
		const person = await Person.getForPlayer(player);
		if (!person) {
			return;
		}
		AdventCalendar.claimAdventReward(person, day);
	});

	// Set up periodic checks for new days
	task.spawn(() => {
		while (true) {
			task.wait(300); // Check every 5 minutes
			for (const player of Players.GetPlayers()) {
				task.spawn(async () => {
					const person = await Person.getForPlayer(player);
					if (person) {
						AdventCalendar.updateAdventCalendarData(person);
					}
				});
			}
		}
	});
}

//[=[
//   This function is used for initialization. It should be called before `start()` to set up the provider.
//
//   ```ts
//   init();
//   ```
//]=]
function init(): void {
	// Load default configuration
	loadDefaultConfig();

	// Set up person events
	Person.personAdded.Connect((person: Person) => {
		AdventCalendar.updateAdventCalendarData(person);
	});
}

export default {
	version: version,

	// Functions
	start: start,
	init: init,
	setAdventCalendarConfig: AdventCalendar.setAdventCalendarConfig,
	getCurrentDay: AdventCalendar.getCurrentDay,
	claimAdventReward: AdventCalendar.claimAdventReward,
	canClaimAdventReward: AdventCalendar.canClaimAdventReward,
	getClaimedDays: AdventCalendar.getClaimedDays,
	getOnlineDays: AdventCalendar.getOnlineDays,
	getTimeUntilNextDay: AdventCalendar.getTimeUntilNextDay,
	isAdventCalendarActive: AdventCalendar.isAdventCalendarActive,

	// Events
	dayUnlocked: AdventCalendar.dayUnlocked,
	rewardClaimed: AdventCalendar.rewardClaimed,
	calendarEnded: AdventCalendar.calendarEnded,
};
