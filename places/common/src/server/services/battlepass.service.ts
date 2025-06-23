import { Service, OnInit } from "@flamework/core";
import { Players } from "@rbxts/services";
import { DataService } from "./data.service";

const version = { major: 1, minor: 0, patch: 0 };

// Battlepass constants
const XP_PER_TIER = 1000;
const MAX_TIER = 100;
const PREMIUM_COST = 1200; // Gems cost for premium

export interface BattlepassReward {
	Gold?: number;
	Gems?: number;
	Items?: Record<string, number>;
	Units?: Record<string, number>;
	Titles?: string[];
}

export interface BattlepassConfig {
	seasonName: string;
	maxTier: number;
	xpPerTier: number;
	premiumCost: number;
	rewards: Record<number, { free?: BattlepassReward; premium?: BattlepassReward }>;
}

/**
 * Battlepass system for managing seasonal progression and rewards.
 */
@Service()
export class BattlepassService implements OnInit {
	public readonly version = version;

	// Default configuration - would be loaded from game configuration in production
	private config: BattlepassConfig = {
		seasonName: "Season 1",
		maxTier: MAX_TIER,
		xpPerTier: XP_PER_TIER,
		premiumCost: PREMIUM_COST,
		rewards: {
			1: { free: { Gold: 100 }, premium: { Gold: 200 } },
			2: { free: { Gems: 10 }, premium: { Gems: 50 } },
			3: { free: { Gold: 200 }, premium: { Gold: 400 } },
			5: { free: { Gems: 25 }, premium: { Gems: 100 } },
			10: { free: { Gold: 500, Gems: 50 }, premium: { Gold: 1000, Gems: 200 } },
			15: { free: { Gold: 750 }, premium: { Gold: 1500, Items: { Premium_Item: 1 } } },
			20: { free: { Gems: 100 }, premium: { Gems: 300, Titles: ["Battlepass Champion"] } },
			25: { free: { Gold: 1000 }, premium: { Gold: 2000, Units: { Legendary_Unit: 1 } } },
		},
	};

	constructor(private readonly dataService: DataService) {}

	public onInit(): void {
		print("BattlepassService initialized");
	}

	/**
	 * Sets the battlepass configuration
	 */
	public setConfig(config: BattlepassConfig): void {
		this.config = config;
	}

	/**
	 * Adds XP to a player's battlepass
	 */
	public async addBattlepassXP(player: Player, amount: number): Promise<void> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get data for player ${player.Name}`);
			return;
		}

		const newData = { ...playerData };
		const bpData = newData.BattlepassData;
		const oldXP = bpData.Exp;
		const oldTier = bpData.Level;

		// Add XP
		bpData.Exp = oldXP + amount;

		// Calculate new tier
		const newTier = math.min(math.floor(bpData.Exp / this.config.xpPerTier) + 1, this.config.maxTier);

		// Update tier if changed
		if (newTier > oldTier) {
			bpData.Level = newTier;
			print(`${player.DisplayName} reached Battlepass tier ${newTier}!`);
		}

		this.dataService.setCache(player, newData);
		print(`${player.DisplayName} gained ${amount} Battlepass XP (Total: ${bpData.Exp})`);
	}

	/**
	 * Claims a battlepass reward for a specific tier
	 */
	public async claimBattlepassReward(player: Player, tier: number, isPremium: boolean): Promise<boolean> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get data for player ${player.Name}`);
			return false;
		}

		const bpData = playerData.BattlepassData;

		// Check if tier is unlocked
		if (bpData.Level < tier) {
			warn(`Player ${player.Name} hasn't unlocked tier ${tier} yet`);
			return false;
		}

		// Check if premium is required and player has it
		if (isPremium && !bpData.HasPremium) {
			warn(`Player ${player.Name} doesn't have premium battlepass`);
			return false;
		}

		// Check if reward was already claimed
		const claimedField = isPremium ? bpData.ClaimedPremium : bpData.ClaimedFree;
		const tierBit = 2 ** (tier - 1);
		if ((claimedField & tierBit) !== 0) {
			warn(`Player ${player.Name} already claimed tier ${tier} ${isPremium ? "premium" : "free"} reward`);
			return false;
		}

		// Get and validate reward
		const reward = this.getBattlepassReward(tier, isPremium);
		if (!reward) {
			warn(`No reward configured for tier ${tier} ${isPremium ? "premium" : "free"}`);
			return false;
		}

		// Give the reward
		await this.giveBattlepassReward(player, reward);

		// Mark as claimed
		const newData = { ...playerData };
		if (isPremium) {
			newData.BattlepassData.ClaimedPremium = bpData.ClaimedPremium | tierBit;
		} else {
			newData.BattlepassData.ClaimedFree = bpData.ClaimedFree | tierBit;
		}

		this.dataService.setCache(player, newData);

		print(`${player.DisplayName} claimed tier ${tier} ${isPremium ? "premium" : "free"} battlepass reward!`);
		return true;
	}

	/**
	 * Purchases premium battlepass for a player
	 */
	public async purchasePremiumBattlepass(player: Player): Promise<boolean> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get data for player ${player.Name}`);
			return false;
		}

		const bpData = playerData.BattlepassData;
		if (bpData.HasPremium) {
			warn(`Player ${player.Name} already has premium battlepass`);
			return false;
		}

		// Check if player has enough currency
		const currencies = playerData.Currencies;
		if ((currencies.Gems ?? 0) < this.config.premiumCost) {
			warn(`Player ${player.Name} doesn't have enough gems for premium battlepass`);
			return false;
		}

		// Purchase premium
		const newData = { ...playerData };
		newData.Currencies.Gems = (currencies.Gems ?? 0) - this.config.premiumCost;
		newData.BattlepassData.HasPremium = true;

		this.dataService.setCache(player, newData);

		print(`${player.DisplayName} purchased premium battlepass!`);
		return true;
	}

	/**
	 * Gets a battlepass reward for a specific tier
	 */
	private getBattlepassReward(tier: number, isPremium: boolean): BattlepassReward | undefined {
		const tierRewards = this.config.rewards[tier];
		if (!tierRewards) {
			return undefined;
		}

		return isPremium ? tierRewards.premium : tierRewards.free;
	}

	/**
	 * Gives a battlepass reward to a player
	 */
	private async giveBattlepassReward(player: Player, reward: BattlepassReward): Promise<void> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get data for player ${player.Name}`);
			return;
		}

		const newData = { ...playerData };

		// Add currencies
		if (reward.Gold !== undefined) {
			newData.Currencies.Gold = (newData.Currencies.Gold ?? 0) + reward.Gold;
		}
		if (reward.Gems !== undefined) {
			newData.Currencies.Gems = (newData.Currencies.Gems ?? 0) + reward.Gems;
		}

		// Add items
		if (reward.Items !== undefined) {
			for (const [itemId, amount] of pairs(reward.Items)) {
				if (!newData.Inventory.Items[itemId]) {
					newData.Inventory.Items[itemId] = { Count: 0, Cost: 0 };
				}
				newData.Inventory.Items[itemId].Count += amount;
			}
		}

		// Add units (would need unit system implemented)
		if (reward.Units !== undefined) {
			for (const [unitId, amount] of pairs(reward.Units)) {
				// Unit giving logic would go here when unit system is implemented
				print(`Would give ${amount}x ${unitId} to ${player.DisplayName}`);
			}
		}

		// Add titles (would need title system implemented)
		if (reward.Titles !== undefined) {
			for (const title of reward.Titles) {
				// Title giving logic would go here when title system is implemented
				print(`Would give title "${title}" to ${player.DisplayName}`);
			}
		}

		this.dataService.setCache(player, newData);
	}

	/**
	 * Gets the current battlepass tier for a player
	 */
	public async getCurrentTier(player: Player): Promise<number> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return 1;
		}
		return playerData.BattlepassData.Level ?? 1;
	}

	/**
	 * Gets the current battlepass XP for a player
	 */
	public async getCurrentXP(player: Player): Promise<number> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return 0;
		}
		return playerData.BattlepassData.Exp ?? 0;
	}

	/**
	 * Checks if a player has premium battlepass
	 */
	public async hasPremium(player: Player): Promise<boolean> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return false;
		}
		return playerData.BattlepassData.HasPremium || false;
	}

	/**
	 * Resets battlepass for new season
	 */
	public async resetBattlepass(player: Player, seasonName: string): Promise<void> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get data for player ${player.Name}`);
			return;
		}

		const newData = { ...playerData };
		const bpData = newData.BattlepassData;

		// Reset progress
		bpData.Exp = 0;
		bpData.Level = 1;
		bpData.HasPremium = false;
		bpData.ClaimedFree = 0;
		bpData.ClaimedPremium = 0;
		bpData.BattlepassName = seasonName;

		this.dataService.setCache(player, newData);

		print(`Reset battlepass for ${player.DisplayName} to season: ${seasonName}`);
	}

	/**
	 * Gets XP needed for next tier
	 */
	public async getXPForNextTier(player: Player): Promise<number> {
		const currentTier = await this.getCurrentTier(player);
		const currentXP = await this.getCurrentXP(player);

		if (currentTier >= this.config.maxTier) {
			return 0; // Max tier reached
		}

		const xpForNextTier = currentTier * this.config.xpPerTier;
		return math.max(0, xpForNextTier - currentXP);
	}

	/**
	 * Gets progress percentage for current tier
	 */
	public async getTierProgress(player: Player): Promise<number> {
		const currentTier = await this.getCurrentTier(player);
		const currentXP = await this.getCurrentXP(player);

		if (currentTier >= this.config.maxTier) {
			return 100; // Max tier reached
		}

		const xpForCurrentTier = (currentTier - 1) * this.config.xpPerTier;
		const xpInCurrentTier = currentXP - xpForCurrentTier;
		const progressPercent = (xpInCurrentTier / this.config.xpPerTier) * 100;

		return math.min(100, math.max(0, progressPercent));
	}

	/**
	 * Checks if a reward can be claimed
	 */
	public async canClaimReward(player: Player, tier: number, isPremium: boolean): Promise<boolean> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return false;
		}

		const bpData = playerData.BattlepassData;

		// Check if tier is unlocked
		if (bpData.Level < tier) {
			return false;
		}

		// Check if premium is required and player has it
		if (isPremium && !bpData.HasPremium) {
			return false;
		}

		// Check if reward was already claimed
		const claimedField = isPremium ? bpData.ClaimedPremium : bpData.ClaimedFree;
		const tierBit = 2 ** (tier - 1);
		if ((claimedField & tierBit) !== 0) {
			return false;
		}

		// Check if reward exists
		const reward = this.getBattlepassReward(tier, isPremium);
		return reward !== undefined;
	}

	/**
	 * Gets all available rewards for a tier
	 */
	public getRewardsForTier(tier: number): { free?: BattlepassReward; premium?: BattlepassReward } | undefined {
		return this.config.rewards[tier];
	}

	/**
	 * Gets current season name
	 */
	public getCurrentSeason(): string {
		return this.config.seasonName;
	}
}
