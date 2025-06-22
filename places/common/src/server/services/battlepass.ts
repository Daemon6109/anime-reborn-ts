// battlepass
--------------------------------------------------------------------------------

import { Network } from "@network/server";
import { Person } from "@commonserver/person";
import Shingo from "@pkgs/shingo";
import { Players } from "@rbxts/services";

const version = { major: 1, minor: 0, patch: 0 };

// Battlepass constants
const XP_PER_TIER = 1000;
const MAX_TIER = 100;
const PREMIUM_COST = 1200; // Robux

// Create signals for battlepass events
const xpGainedEvent = new Shingo<{ player: Player; amount: number; totalXP: number }>();
const tierUnlockedEvent = new Shingo<{ player: Player; tier: number }>();
const rewardClaimedEvent = new Shingo<{ player: Player; tier: number; isPremium: boolean; reward: any }>();

interface BattlepassData {
	Exp: number;
	Level: number;
	HasPremium: boolean;
	ClaimedFree: number;
	ClaimedPremium: number;
	BattlepassName: string;
}

//[=[
//   Battlepass system for managing seasonal progression.
//
//   @class Battlepass
//]=]
const Battlepass = {
	version: version,
	// Events
	xpGained: xpGainedEvent,
	tierUnlocked: tierUnlockedEvent,
	rewardClaimed: rewardClaimedEvent,

	//[=[
	//   Adds XP to a person's battlepass
	//
	//   @within Battlepass
	//
	//   @param person Person -- The person to add XP to
	//   @param amount number -- The amount of XP to add
	//
	//   ```ts
	//   Battlepass.addBattlepassXP(person, 500);
	//   ```
	//]=]
	addBattlepassXP(person: Person, amount: number): void {
		person.dataCache((dataCache) => {
			const bpData = dataCache.BattlepassData as BattlepassData;
			const oldXP = bpData.Exp;
			const oldTier = bpData.Level;
			bpData.Exp = oldXP + amount;
			const newTier = Math.min(Math.floor(bpData.Exp / XP_PER_TIER) + 1, MAX_TIER);
			if (newTier > oldTier) {
				bpData.Level = newTier;
				tierUnlockedEvent.fire({ player: person.player, tier: newTier });
			}
			xpGainedEvent.fire({ player: person.player, amount: amount, totalXP: bpData.Exp });
			return dataCache;
		});
	},

	//[=[
	//   Claims a battlepass reward for a specific tier
	//
	//   @within Battlepass
	//
	//   @param person Person -- The person claiming the reward
	//   @param tier number -- The tier to claim the reward for
	//   @param isPremium boolean -- Whether the reward is for premium tier
	//
	//   @return boolean -- Whether the reward was successfully claimed
	//
	//   ```ts
	//   const success = Battlepass.claimBattlepassReward(person, 5, true);
	//   if (success) {
	// 	   print("Reward claimed successfully!");
	//   } else {
	// 	   print("Failed to claim reward.");
	//   }
	//   ```
	//]=]
	claimBattlepassReward(person: Person, tier: number, isPremium: boolean): boolean {
		const cache = person.dataCache();
		const bpData = cache.BattlepassData as BattlepassData;
		// Check if tier is unlocked
		if (bpData.Level < tier) {
			return false;
		}
		// Check if premium is required and player has it
		if (isPremium && !bpData.HasPremium) {
			return false;
		}
		// Check if reward was already claimed
		const claimedField = isPremium ? "ClaimedPremium" : "ClaimedFree";
		const claimedMask = bpData[claimedField] || 0;
		const tierBit = 2 ** (tier - 1);
		if ((claimedMask & tierBit) !== 0) {
			return false; // Already claimed
		}
		// Get and give the reward
		const reward = Battlepass.getBattlepassReward(tier, isPremium);
		if (reward) {
			Battlepass.giveBattlepassReward(person, reward);
			// Mark as claimed
			person.dataCache((dataCache) => {
				const bpDataUpdate = dataCache.BattlepassData as BattlepassData;
				bpDataUpdate[claimedField] = (bpDataUpdate[claimedField] || 0) | tierBit;
				return dataCache;
			});
			rewardClaimedEvent.fire({ player: person.player, tier: tier, isPremium: isPremium, reward: reward });
			return true;
		}
		return false;
	},

	//[=[
	//   Purchases premium battlepass for a person
	//
	//   @within Battlepass
	//
	//   @param person Person -- The person to purchase premium for
	//
	//   @return boolean -- Whether the purchase was successful
	//
	//   ```ts
	//   const success = Battlepass.purchasePremiumBattlepass(person);
	//   if (success) {
	// 	   print("Premium battlepass purchased successfully!");
	//   } else {
	// 	   print("Failed to purchase premium battlepass.");
	//   }
	//   ```
	//]=]
	purchasePremiumBattlepass(person: Person): boolean {
		const cache = person.dataCache();
		let bpData = cache.BattlepassData as BattlepassData;
		if (bpData.HasPremium) {
			return false; // Already has premium
		}
		// Check if player has enough currency (this would typically check Robux)
		const currencies = cache.Currencies;
		if ((currencies.Gems || 0) < PREMIUM_COST) {
			return false;
		}
		// Purchase premium
		person.dataCache((dataCache) => {
			bpData = dataCache.BattlepassData as BattlepassData;
			// Deduct cost
			currencies.Gems = (currencies.Gems || 0) - PREMIUM_COST;
			// Grant premium
			bpData.HasPremium = true;
			return dataCache;
		});
		return true;
	},

	//[=[
	//   Gets a battlepass reward for a specific tier
	//
	//   @within Battlepass
	//
	//   @param tier number -- The tier to get the reward for
	//   @param isPremium boolean -- Whether the reward is for premium tier
	//
	//   @return { [key: string]: any } | undefined -- The reward for the tier, or undefined if no reward
	//
	//   ```ts
	//   const reward = Battlepass.getBattlepassReward(5, true);
	//   if (reward) {
	// 	   print("Reward for tier 5:", reward);
	//   } else {
	// 	   print("No reward for this tier.");
	//   }
	//   ```
	//]=]
	getBattlepassReward(tier: number, isPremium: boolean): { [key: string]: any } | undefined {
		// Basic reward structure - in a real implementation this would come from configuration
		const rewards: { [tier: number]: { [key: string]: any } } = {
			1: { Gold: isPremium ? 200 : 100 },
			2: { Gold: 0, Gems: isPremium ? 50 : 10 },
			3: { Gold: isPremium ? 400 : 200 },
			5: { Gold: 0, Gems: isPremium ? 100 : 25 },
			10: { Gold: isPremium ? 1000 : 500, Gems: isPremium ? 200 : 50 },
		};
		return rewards[tier];
	},

	//[=[
	//   Gives a battlepass reward to a person
	//
	//   @within Battlepass
	//
	//   @param person Person -- The person to give the reward to
	//   @param reward { [key: string]: any } -- The reward to give (e.g. { Gold: 100, Gems: 50 })
	//
	//   ```ts
	//   Battlepass.giveBattlepassReward(person, { Gold: 100, Gems: 50 });
	//   ```
	//]=]
	giveBattlepassReward(person: Person, reward: { [key: string]: any }): void {
		person.dataCache((dataCache) => {
			const currencies = dataCache.Currencies;
			// Add currencies
			if (reward.Gold) {
				currencies.Gold = (currencies.Gold || 0) + reward.Gold;
			}
			if (reward.Gems) {
				currencies.Gems = (currencies.Gems || 0) + reward.Gems;
			}
			return dataCache;
		});
	},

	//[=[
	//   Gets the current battlepass tier for a person
	//
	//   @within Battlepass
	//
	//   @param person Person -- The person to get tier for
	//
	//   @return number -- The current battlepass tier
	//
	//   ```ts
	//   const currentTier = Battlepass.getCurrentTier(person);
	//   print("Current Battlepass Tier:", currentTier);
	//   ```
	//]=]
	getCurrentTier(person: Person): number {
		const dataCache = person.dataCache();
		return (dataCache.BattlepassData as BattlepassData).Level || 1;
	},

	//[=[
	//   Gets the current battlepass XP for a person
	//
	//   @within Battlepass
	//
	//   @param person Person -- The person to get XP for
	//
	//   @return number -- The current battlepass XP
	//
	//   ```ts
	//   const currentXP = Battlepass.getCurrentXP(person);
	//   print("Current Battlepass XP:", currentXP);
	//   ```
	//]=]
	getCurrentXP(person: Person): number {
		const dataCache = person.dataCache();
		return (dataCache.BattlepassData as BattlepassData).Exp || 0;
	},

	//[=[
	//   Checks if a person has premium battlepass
	//
	//   @within Battlepass
	//
	//   @param person Person -- The person to check
	//
	//   @return boolean -- Whether the person has premium battlepass
	//
	//   ```ts
	//   const hasPremium = Battlepass.hasPremium(person);
	//   if (hasPremium) {
	// 	   print("Player has premium battlepass!");
	//   } else {
	// 	   print("Player does not have premium battlepass.");
	//   }
	//   ```
	//]=]
	hasPremium(person: Person): boolean {
		const dataCache = person.dataCache();
		return (dataCache.BattlepassData as BattlepassData).HasPremium || false;
	},

	//[=[
	//   Resets battlepass for new season
	//
	//   @within Battlepass
	//
	//   @param person Person -- The person whose battlepass to reset
	//   @param seasonName string -- The name of the new season
	//
	//   ```ts
	//   Battlepass.resetBattlepass(person, "Season 2");
	//   ```
	//]=]
	resetBattlepass(person: Person, seasonName: string): void {
		person.dataCache((dataCache) => {
			const bpData = dataCache.BattlepassData as BattlepassData;
			// Reset progress but keep premium status for this example
			bpData.Exp = 0;
			bpData.Level = 1;
			bpData.HasPremium = false;
			bpData.ClaimedFree = 0;
			bpData.ClaimedPremium = 0;
			bpData.BattlepassName = seasonName;
			return dataCache;
		});
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
	// Claim battlepass reward event
	Network.ClaimBattlepassReward.on(async (player, data) => {
		const person = await Person.getForPlayer(player);
		assert(person);
		Battlepass.claimBattlepassReward(person, data.tier, data.isPremium);
	});
	// Purchase premium battlepass event
	Network.PurchasePremiumBattlepass.on(async (player) => {
		const person = await Person.getForPlayer(player);
		assert(person);
		Battlepass.purchasePremiumBattlepass(person);
	});
}

//[=[
//   This function is used for initialization. It should be called before `start()` to set up the provider.
//
//   ```ts
//   init();
//   ```
//]=]
function init(): void {}

export default {
	version: version,
	order: 20, // Initialize after Person system
	// Functions
	init: init,
	start: start,
	addBattlepassXP: Battlepass.addBattlepassXP,
	claimBattlepassReward: Battlepass.claimBattlepassReward,
	purchasePremiumBattlepass: Battlepass.purchasePremiumBattlepass,
	getCurrentTier: Battlepass.getCurrentTier,
	getCurrentXP: Battlepass.getCurrentXP,
	hasPremium: Battlepass.hasPremium,
	resetBattlepass: Battlepass.resetBattlepass,
	// Events
	xpGained: xpGainedEvent,
	tierUnlocked: tierUnlockedEvent,
	rewardClaimed: rewardClaimedEvent,
};
