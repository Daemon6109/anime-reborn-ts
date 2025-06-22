// daily_rewards
--------------------------------------------------------------------------------

import { Network } from "@network/server";
import { Person } from "@commonserver/person";
import Shingo from "@pkgs/shingo";
import { Players } from "@rbxts/services";

const version = { major: 1, minor: 0, patch: 0 };

// Daily reward constants
const MAX_STREAK_DAYS = 7; // Reset streak after 7 days
const BASE_REWARD_COINS = 100;
const STREAK_MULTIPLIER = 1.5;

// Create signals for daily reward events
const rewardClaimedEvent = new Shingo<any>();
const newDayEvent = new Shingo<any>();

interface DailyRewardsData {
	LastClaimedDay?: number;
	CurrentStreak?: number;
	CanClaim?: boolean;
	TotalClaimed?: number;
}

//[=[
//   Daily Rewards system for managing daily login rewards.
//
//   @class DailyRewards
//]=]
const DailyRewards = {
	version: version,

	// Events
	rewardClaimed: rewardClaimedEvent,
	newDay: newDayEvent,

	//[=[
	//   Checks if it's a new day and resets daily data if necessary
	//
	//   @within DailyRewards
	//
	//   @param person Person -- The person to check daily reset for
	//
	//   ```ts
	//   DailyRewards.checkDailyReset(person);
	//   ```
	//]=]
	checkDailyReset(person: Person): void {
		const currentTime = os.time();
		const currentDay = Math.floor(currentTime / 86400); // Days since epoch

		person.dataCache((dataCache) => {
			const newCache = { ...dataCache };
			const dailyData = newCache.DailyRewardsData as DailyRewardsData;

			if (dailyData.LastClaimedDay === undefined || dailyData.LastClaimedDay < currentDay) {
				// New day detected
				if (dailyData.LastClaimedDay !== undefined && currentDay - dailyData.LastClaimedDay > 1) {
					// Streak broken - reset to day 1
					dailyData.CurrentStreak = 1;
				} else {
					// Continue streak
					dailyData.CurrentStreak = Math.min((dailyData.CurrentStreak || 0) + 1, MAX_STREAK_DAYS);
				}

				dailyData.CanClaim = true;
				newDayEvent.fire({ player: person.player, day: dailyData.CurrentStreak });
			}

			return newCache;
		});
	},

	//[=[
	//   Claims the daily reward for a person
	//
	//   @within DailyRewards
	//
	//   @param person Person -- The person claiming the reward
	//
	//   @return boolean -- Returns true if the reward was successfully claimed, false otherwise
	//
	//   ```ts
	//   const success = DailyRewards.claimDailyReward(person);
	//   if (success) {
	// 	   print("Reward claimed successfully!");
	//   } else {
	// 	   print("You cannot claim the reward yet.");
	//   }
	//   ```
	//]=]
	claimDailyReward(person: Person): boolean {
		const cache = person.dataCache();
		const dailyData = cache.DailyRewardsData as DailyRewardsData;

		if (!dailyData.CanClaim) {
			return false;
		}

		const currentDay = dailyData.CurrentStreak || 1;
		const reward = DailyRewards.calculateDailyReward(currentDay);
		DailyRewards.giveReward(person, reward);

		// Update daily data
		person.dataCache((dataCache) => {
			const newCache = { ...dataCache };
			const dailyDataUpdate = newCache.DailyRewardsData as DailyRewardsData;

			dailyDataUpdate.CanClaim = false;
			dailyDataUpdate.LastClaimedDay = Math.floor(os.time() / 86400);
			dailyDataUpdate.TotalClaimed = (dailyDataUpdate.TotalClaimed || 0) + 1;

			return newCache;
		});

		// Fire event
		rewardClaimedEvent.fire({ player: person.player, day: currentDay, reward: reward });

		return true;
	},

	//[=[
	//   Calculates the daily reward based on the current day
	//
	//   @within DailyRewards
	//
	//   @param day number -- The current day in the streak (1-7)
	//
	//   @return { [key: string]: number } -- The reward for the given day
	//
	//   ```ts
	//   const reward = DailyRewards.calculateDailyReward(3);
	//   print(`Reward for day 3: ${reward.Coins} coins and ${reward.Gems} gems`);
	//   ```
	//]=]
	calculateDailyReward(day: number): { [key: string]: number } {
		const baseCoins = BASE_REWARD_COINS;
		const streakBonus = Math.floor(baseCoins * (day - 1) * STREAK_MULTIPLIER);

		const reward: { [key: string]: number } = {
			Coins: baseCoins + streakBonus,
		};

		// Special rewards for certain days
		if (day === 3) {
			reward.Gems = 10;
		} else if (day === 7) {
			reward.Gems = 25;
			reward.BonusCoins = 500;
		}

		return reward;
	},

	//[=[
	//   Gives a reward to a person
	//
	//   @within DailyRewards
	//
	//   @param person Person -- The person to give the reward to
	//   @param reward { [key: string]: number } -- The reward to give (e.g., { Coins: 100, Gems: 10 })
	//
	//   ```ts
	//   DailyRewards.giveReward(person, { Coins: 100, Gems: 10 });
	//   ```
	//]=]
	giveReward(person: Person, reward: { [key: string]: number }): void {
		person.dataCache((dataCache) => {
			const newCache = { ...dataCache };
			const currencies = newCache.Currencies;

			// Add coins
			if (reward.Coins) {
				currencies.Gold = (currencies.Gold || 0) + reward.Coins;
			}

			// Add gems
			if (reward.Gems) {
				currencies.Gems = (currencies.Gems || 0) + reward.Gems;
			}

			// Add bonus coins
			if (reward.BonusCoins) {
				currencies.Gold = (currencies.Gold || 0) + reward.BonusCoins;
			}

			return newCache;
		});
	},

	//[=[
	//   Gets the current daily reward status for a person
	//
	//   @param person Person -- The person to get the daily status for
	//
	//   @return { currentDay: number, canClaim: boolean, totalClaimed: number } -- The daily status
	//
	//   ```ts
	//   const status = DailyRewards.getDailyStatus(person);
	//   print(`Current Day: ${status.currentDay}`);
	//   print(`Can Claim Reward: ${status.canClaim}`);
	//   print(`Total Claimed: ${status.totalClaimed}`);
	//   ```
	//]=]
	getDailyStatus(person: Person): { currentDay: number; canClaim: boolean; totalClaimed: number } {
		const cache = person.dataCache();
		const dailyData = cache.DailyRewardsData as DailyRewardsData;

		return {
			currentDay: dailyData.CurrentStreak || 1,
			canClaim: dailyData.CanClaim || false,
			totalClaimed: dailyData.TotalClaimed || 0,
		};
	},
};

//[=[
//   This function is used to start the provider and initialize any necessary systems.
//
//   ```ts
//   start();
//   ```
//]=]
async function start(): Promise<void> {
	// Set up Blink network event for daily reward claiming
	Network.ClaimDailyReward.on(async (player: Player) => {
		const person = await Person.getForPlayer(player);
		if (!person) {
			return;
		}

		DailyRewards.claimDailyReward(person);
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
	// Check for daily resets when players join
	Person.personAdded.Connect(async (person: Person) => {
		task.wait(1); // Wait for data to load
		DailyRewards.checkDailyReset(person);
	});

	// Set up periodic daily reset checks (every hour)
	task.spawn(async () => {
		while (true) {
			task.wait(3600); // Check every hour
			for (const player of Players.GetPlayers()) {
				const person = await Person.getForPlayer(player);
				if (person) {
					DailyRewards.checkDailyReset(person);
				}
			}
		}
	});
}

export default {
	version: version,
	order: 15, // Initialize after Person system

	// Functions
	init: init,
	start: start,
	claimDailyReward: DailyRewards.claimDailyReward,
	getDailyStatus: DailyRewards.getDailyStatus,

	// Events
	rewardClaimed: rewardClaimedEvent,
	newDay: newDayEvent,
};
