import { Service, OnInit } from "@flamework/core";
import { DataStore } from "@server/services/player-data";
import { Analytics } from "@server/services/analytics";
import {
	battlepassData,
	BattlepassName,
	BattlepassConfig,
	BattlepassReward,
	BattlepassLevelData,
	BATTLEPASS_NAMES,
	getExactBattlepass,
	getExactLevelData,
	getExactLevelReward,
} from "@shared/types/battlepass-data";

const version = { major: 1, minor: 0, patch: 0 };

/**
 * Battlepass system for managing seasonal progression and rewards.
 */
@Service()
export class BattlepassService implements OnInit {
	public readonly version = version;

	// Get the active battlepass configuration from JSON data based on current date
	private getConfig(): BattlepassConfig {
		const activeBattlepassName = this.getActiveBattlepassName();
		const config = getExactBattlepass(activeBattlepassName as BattlepassName);
		if (!config) {
			warn(`Failed to get config for battlepass: ${activeBattlepassName}`);
			// Fallback to the first available battlepass
			const firstBattlepass = BATTLEPASS_NAMES[0];
			return getExactBattlepass(firstBattlepass)!;
		}
		return config;
	}

	/**
	 * Determines the active battlepass based on current date and end dates
	 */
	private getActiveBattlepassName(): BattlepassName {
		const now = DateTime.now();
		const currentTimestamp = now.UnixTimestamp;

		// Get all battlepass names and their end dates
		const battlepassInfo: Array<{ name: BattlepassName; endTimestamp: number }> = [];

		for (const battlepassName of BATTLEPASS_NAMES) {
			const config = getExactBattlepass(battlepassName);
			if (!config) continue;

			const endDate = config.EndDate;
			if (endDate !== undefined && endDate.size() >= 3) {
				const endDateTime = DateTime.fromLocalTime(endDate[0], endDate[1], endDate[2]);
				battlepassInfo.push({
					name: battlepassName,
					endTimestamp: endDateTime.UnixTimestamp,
				});
			}
		}

		// Sort by end date (earliest first)
		battlepassInfo.sort((a, b) => a.endTimestamp < b.endTimestamp);

		// Find the first battlepass that hasn't ended yet
		for (const battlepass of battlepassInfo) {
			if (currentTimestamp < battlepass.endTimestamp) {
				return battlepass.name;
			}
		}

		// If all battlepasses have ended, return the last one (most recent)
		if (battlepassInfo.size() > 0) {
			return battlepassInfo[battlepassInfo.size() - 1].name;
		}

		// Fallback to "Pixel Pass" if no battlepasses found
		return "Pixel Pass";
	}

	// Derived properties for compatibility
	private getMaxTier(): number {
		const config = this.getConfig();
		const levelKeys = [];
		for (const [key] of pairs(config.LevelData)) {
			const numKey = tonumber(key);
			if (numKey !== undefined) {
				levelKeys.push(numKey);
			}
		}
		return math.max(...levelKeys);
	}

	private getXpPerTier(): number {
		// Get XP from first level as baseline
		const config = this.getConfig();
		const firstLevel = config.LevelData["1"];
		return firstLevel ? firstLevel.Exp : 1250;
	}

	constructor(
		private readonly dataService: DataStore,
		private readonly analytics: Analytics,
	) {}

	public onInit(): void {
		const activeBattlepass = this.getActiveBattlepassName();
		print(`BattlepassService initialized - Active battlepass: ${activeBattlepass}`);

		// Log all available battlepasses for debugging
		const allBattlepasses = this.getAllBattlepasses();
		for (const bp of allBattlepasses) {
			const status = bp.isActive ? "ACTIVE" : bp.hasEnded ? "ENDED" : "UPCOMING";
			print(`  - ${bp.name}: ${status} (ends ${bp.endDate[0]}-${bp.endDate[1]}-${bp.endDate[2]})`);
		}

		// Log system initialization (analytics will be tracked per-player when they interact)
		print(
			`Battlepass system ready - ${activeBattlepass} is active with ${allBattlepasses.size()} total battlepasses`,
		);
	}

	/**
	 * Gets the currently active battlepass name (calculated based on current date)
	 */
	public getActiveBattlepass(): BattlepassName {
		return this.getActiveBattlepassName();
	}

	/**
	 * Adds XP to a player's battlepass
	 */
	public async addBattlepassXP(player: Player, amount: number): Promise<void> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			await playerStore.updateAsync(player, (playerData) => {
				const bpData = playerData.battlepass[0]; // Get the first (and only) battlepass data
				const oldXP = bpData.xp;
				const oldTier = bpData.level;

				// Add XP
				bpData.xp = oldXP + amount;

				// Calculate new tier
				const maxTier = this.getMaxTier();
				const xpPerTier = this.getXpPerTier();
				const newTier = math.min(math.floor(bpData.xp / xpPerTier) + 1, maxTier);

				// Update tier if changed
				if (newTier > oldTier) {
					bpData.level = newTier;
					print(`${player.DisplayName} reached Battlepass tier ${newTier}!`);

					// Analytics: Track tier progression
					this.analytics.LogProgressionEvent(
						player,
						"Battlepass",
						Enum.AnalyticsProgressionType.Complete,
						newTier,
						`Tier ${newTier}`,
						{
							battlepass_name: this.getActiveBattlepass(),
							previous_tier: tostring(oldTier),
							xp_gained: tostring(amount),
							total_xp: tostring(bpData.xp),
						},
					);

					// Track funnel progression for tier unlock
					this.trackBattlepassFunnel(player, "tier_unlock");
				}

				print(`${player.DisplayName} gained ${amount} Battlepass XP (Total: ${bpData.xp})`);

				// Analytics: Track XP gain
				this.analytics.LogCustomEvent(player, "battlepass_xp_gained", amount, {
					battlepass_name: this.getActiveBattlepass(),
					current_tier: tostring(bpData.level),
					total_xp: tostring(bpData.xp),
				});

				// Track funnel progression for XP gain
				this.trackBattlepassFunnel(player, "xp_gain");

				return true; // Commit changes
			});
		} catch (error) {
			warn(`Failed to add battlepass XP for player ${player.Name}: ${error}`);
		}
	}

	/**
	 * Claims a battlepass reward for a specific tier
	 */
	public async claimBattlepassReward(player: Player, tier: number, isPremium: boolean): Promise<boolean> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			let rewardClaimed = false;

			await playerStore.updateAsync(player, (playerData) => {
				const bpData = playerData.battlepass[0]; // Get the first (and only) battlepass data

				// Check if tier is unlocked
				if (bpData.level < tier) {
					warn(`Player ${player.Name} hasn't unlocked tier ${tier} yet`);
					return false;
				}

				// Check if premium is required and player has it
				if (isPremium && !bpData.premium) {
					warn(`Player ${player.Name} doesn't have premium battlepass`);
					return false;
				}

				// Check if reward was already claimed
				const tierClaims = bpData.claimed.get(tier);
				if (tierClaims && (isPremium ? tierClaims.premium : tierClaims.basic)) {
					warn(
						`Player ${player.Name} already claimed tier ${tier} ${isPremium ? "premium" : "basic"} reward`,
					);
					return false;
				}

				// Get and validate reward
				const reward = this.getBattlepassReward(tier, isPremium);
				if (!reward) {
					warn(`No reward configured for tier ${tier} ${isPremium ? "premium" : "basic"}`);
					return false;
				}

				// Give the reward directly in the update
				this.giveBattlepassRewardDirect(playerData, reward);

				// Mark as claimed
				const currentClaims = bpData.claimed.get(tier) || { basic: false, premium: false };
				if (isPremium) {
					currentClaims.premium = true;
				} else {
					currentClaims.basic = true;
				}
				bpData.claimed.set(tier, currentClaims);

				rewardClaimed = true;
				print(
					`${player.DisplayName} claimed tier ${tier} ${isPremium ? "premium" : "basic"} battlepass reward!`,
				);

				// Analytics: Track reward claim
				this.analytics.LogCustomEvent(player, "battlepass_reward_claimed", 1, {
					battlepass_name: this.getActiveBattlepass(),
					tier: tostring(tier),
					reward_type: isPremium ? "premium" : "basic",
					player_tier: tostring(bpData.level),
				});

				// Track funnel progression for reward claim
				this.trackBattlepassFunnel(player, "reward_claim");

				return true; // Commit changes
			});

			return rewardClaimed;
		} catch (error) {
			warn(`Failed to claim battlepass reward for player ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Purchases premium battlepass for a player
	 */
	public async purchasePremiumBattlepass(player: Player): Promise<boolean> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			let purchaseSuccessful = false;

			await playerStore.updateAsync(player, (playerData) => {
				const bpData = playerData.battlepass[0]; // Get the first (and only) battlepass data
				if (bpData.premium) {
					warn(`Player ${player.Name} already has premium battlepass`);
					return false;
				}

				// Check if player has enough currency
				const currencies = playerData.items; // Items contain currencies
				// Note: Need to check how currencies are stored in items array
				// For now, assuming a simple structure - this may need adjustment
				warn("Currency checking not yet implemented with new data structure");

				// Purchase premium
				bpData.premium = true;

				purchaseSuccessful = true;
				print(`${player.DisplayName} purchased premium battlepass!`);

				// Analytics: Track premium purchase
				this.analytics.LogEconomyEvent(
					player,
					Enum.AnalyticsEconomyFlowType.Sink,
					"Gems", // Assuming premium costs gems
					0, // TODO: Add actual cost when currency checking is implemented
					0, // TODO: Add actual ending balance when currency checking is implemented
					"Shop",
					`battlepass_${this.getActiveBattlepass()}`,
					{
						battlepass_name: this.getActiveBattlepass(),
						player_tier: tostring(bpData.level),
						purchase_type: "premium_battlepass",
					},
				);

				// Track funnel progression for premium purchase
				this.trackBattlepassFunnel(player, "premium_purchase");

				return true; // Commit changes
			});

			return purchaseSuccessful;
		} catch (error) {
			warn(`Failed to purchase premium battlepass for player ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Gets a battlepass reward for a specific tier
	 */
	private getBattlepassReward(tier: number, isPremium: boolean): BattlepassReward | undefined {
		const config = this.getConfig();
		const tierData = config.LevelData[tostring(tier)];
		if (!tierData) {
			return undefined;
		}

		if (isPremium) {
			return tierData.Premium;
		} else {
			return tierData.Regular;
		}
	}

	/**
	/**
	 * Gives a battlepass reward directly to player data (for use within updateAsync)
	 */
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	private giveBattlepassRewardDirect(playerData: any, reward: BattlepassReward): void {
		// Add direct currencies (legacy Gold/Gems properties)
		if (reward.Gold !== undefined) {
			// TODO: Find or create Gold item in playerData.items array and add to amount
			print(`Would give ${reward.Gold} Gold`);
		}
		if (reward.Gems !== undefined) {
			// TODO: Find or create Gems item in playerData.items array and add to amount
			print(`Would give ${reward.Gems} Gems`);
		}

		// Add currencies from Currencies object
		if (reward.Currencies !== undefined) {
			for (const [currencyId, amount] of pairs(reward.Currencies)) {
				// TODO: Find or create currency item in playerData.items array and add to amount
				print(`Would give ${amount} ${currencyId}`);
			}
		}

		// Add items
		if (reward.Items !== undefined) {
			for (const [itemId, amount] of pairs(reward.Items)) {
				// TODO: Find or create item in playerData.items array and add to amount
				print(`Would give ${amount}x ${itemId}`);
			}
		}

		// Add units (would need unit system implemented)
		if (reward.Units !== undefined) {
			for (const [unitId, amount] of pairs(reward.Units)) {
				// Unit giving logic would go here when unit system is implemented
				print(`Would give ${amount}x ${unitId}`);
			}
		}

		// Add shiny units (would need unit system implemented)
		if (reward.ShinyUnits !== undefined) {
			for (const [unitId, amount] of pairs(reward.ShinyUnits)) {
				// Shiny unit giving logic would go here when unit system is implemented
				print(`Would give ${amount}x Shiny ${unitId}`);
			}
		}

		// Add titles (would need title system implemented)
		if (reward.Titles !== undefined) {
			for (const title of reward.Titles) {
				// Title giving logic would go here when title system is implemented
				print(`Would give title "${title}"`);
			}
		}
	}

	/**
	 * Gets the current battlepass tier for a player
	 */
	public async getCurrentTier(player: Player): Promise<number> {
		const playerStore = this.dataService.getPlayerStore();
		try {
			const data = await playerStore.getAsync(player);
			return data?.battlepass[0]?.level ?? 1;
		} catch (error) {
			warn(`Failed to get current tier for player ${player.Name}: ${error}`);
			return 1;
		}
	}

	/**
	 * Gets the current battlepass XP for a player
	 */
	public async getCurrentXP(player: Player): Promise<number> {
		const playerStore = this.dataService.getPlayerStore();
		try {
			const data = await playerStore.getAsync(player);
			return data?.battlepass[0]?.xp ?? 0;
		} catch (error) {
			warn(`Failed to get current XP for player ${player.Name}: ${error}`);
			return 0;
		}
	}

	/**
	 * Checks if a player has premium battlepass
	 */
	public async hasPremium(player: Player): Promise<boolean> {
		const playerStore = this.dataService.getPlayerStore();
		try {
			const data = await playerStore.getAsync(player);
			return data?.battlepass[0]?.premium ?? false;
		} catch (error) {
			warn(`Failed to check premium status for player ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Resets battlepass for new season
	 */
	public async resetBattlepass(player: Player, seasonName: string): Promise<void> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			await playerStore.updateAsync(player, (playerData) => {
				const bpData = playerData.battlepass[0]; // Get the first (and only) battlepass data

				// Reset progress
				bpData.xp = 0;
				bpData.level = 1;
				bpData.premium = false;
				bpData.claimed.clear(); // Clear all claimed rewards

				print(`Reset battlepass for ${player.DisplayName} to season: ${seasonName}`);

				// Analytics: Track battlepass reset
				this.analytics.LogCustomEvent(player, "battlepass_reset", 1, {
					previous_battlepass: this.getActiveBattlepass(),
					new_season: seasonName,
					reset_timestamp: tostring(DateTime.now().UnixTimestamp),
				});

				return true; // Commit changes
			});
		} catch (error) {
			warn(`Failed to reset battlepass for player ${player.Name}: ${error}`);
		}
	}

	/**
	 * Gets XP needed for next tier
	 */
	public async getXPForNextTier(player: Player): Promise<number> {
		const currentTier = await this.getCurrentTier(player);
		const currentXP = await this.getCurrentXP(player);
		const maxTier = this.getMaxTier();
		const xpPerTier = this.getXpPerTier();

		if (currentTier >= maxTier) {
			return 0; // Max tier reached
		}

		const xpForNextTier = currentTier * xpPerTier;
		return math.max(0, xpForNextTier - currentXP);
	}

	/**
	 * Gets progress percentage for current tier
	 */
	public async getTierProgress(player: Player): Promise<number> {
		const currentTier = await this.getCurrentTier(player);
		const currentXP = await this.getCurrentXP(player);
		const maxTier = this.getMaxTier();
		const xpPerTier = this.getXpPerTier();

		if (currentTier >= maxTier) {
			return 100; // Max tier reached
		}

		const xpForCurrentTier = (currentTier - 1) * xpPerTier;
		const xpInCurrentTier = currentXP - xpForCurrentTier;
		const progressPercent = (xpInCurrentTier / xpPerTier) * 100;

		return math.min(100, math.max(0, progressPercent));
	}

	/**
	 * Checks if a reward can be claimed
	 */
	public async canClaimReward(player: Player, tier: number, isPremium: boolean): Promise<boolean> {
		const playerStore = this.dataService.getPlayerStore();

		try {
			const data = await playerStore.getAsync(player);
			if (!data) {
				return false;
			}

			const bpData = data.battlepass[0]; // Get the first (and only) battlepass data

			// Check if tier is unlocked
			if (bpData.level < tier) {
				return false;
			}

			// Check if premium is required and player has it
			if (isPremium && !bpData.premium) {
				return false;
			}

			// Check if reward was already claimed
			const tierClaims = bpData.claimed.get(tier);
			if (tierClaims && (isPremium ? tierClaims.premium : tierClaims.basic)) {
				return false;
			}

			// Check if reward exists
			const reward = this.getBattlepassReward(tier, isPremium);
			return reward !== undefined;
		} catch (error) {
			warn(`Failed to check if reward can be claimed for player ${player.Name}: ${error}`);
			return false;
		}
	}

	/**
	 * Gets all available rewards for a tier
	 */
	public getRewardsForTier(tier: number): { Regular?: BattlepassReward; Premium?: BattlepassReward } | undefined {
		const activeBattlepassName = this.getActiveBattlepassName() as BattlepassName;
		const levelData = getExactLevelData(activeBattlepassName);
		return levelData[tostring(tier) as keyof typeof levelData];
	}

	/**
	 * Gets current season name
	 */
	public getCurrentSeason(): BattlepassName {
		return this.getActiveBattlepassName();
	}

	/**
	 * Gets the end date of the current battlepass
	 */
	public getEndDate(): [number, number, number] {
		const config = this.getConfig();
		const endDate = config.EndDate;
		return [
			endDate[0] !== undefined ? endDate[0] : 2025,
			endDate[1] !== undefined ? endDate[1] : 6,
			endDate[2] !== undefined ? endDate[2] : 1,
		] as [number, number, number];
	}

	/**
	 * Checks if the currently active battlepass has ended
	 */
	public hasCurrentBattlepassEnded(): boolean {
		const [year, month, day] = this.getEndDate();
		const endDate = DateTime.fromLocalTime(year, month, day);
		const now = DateTime.now();
		return now.UnixTimestamp >= endDate.UnixTimestamp;
	}

	/**
	 * @deprecated Use hasCurrentBattlepassEnded() instead
	 */
	public hasEnded(): boolean {
		return this.hasCurrentBattlepassEnded();
	}

	/**
	 * Gets all available battlepasses with their status
	 */
	public getAllBattlepasses(): Array<{
		name: string;
		endDate: [number, number, number];
		isActive: boolean;
		hasEnded: boolean;
	}> {
		const now = DateTime.now();
		const currentTimestamp = now.UnixTimestamp;
		const activeBattlepass = this.getActiveBattlepassName();

		const battlepasses = [];

		for (const battlepassName of BATTLEPASS_NAMES) {
			const config = getExactBattlepass(battlepassName);
			if (!config) continue;

			const endDate = config.EndDate;
			if (endDate !== undefined && endDate.size() >= 3) {
				const endDateTime = DateTime.fromLocalTime(endDate[0], endDate[1], endDate[2]);
				const hasEnded = currentTimestamp >= endDateTime.UnixTimestamp;
				const isActive = battlepassName === activeBattlepass;

				battlepasses.push({
					name: battlepassName,
					endDate: [endDate[0], endDate[1], endDate[2]] as [number, number, number],
					isActive,
					hasEnded,
				});
			}
		}

		// Sort by end date
		battlepasses.sort((a, b) => {
			const aTime = DateTime.fromLocalTime(a.endDate[0], a.endDate[1], a.endDate[2]).UnixTimestamp;
			const bTime = DateTime.fromLocalTime(b.endDate[0], b.endDate[1], b.endDate[2]).UnixTimestamp;
			return aTime < bTime;
		});

		return battlepasses;
	}

	/**
	 * Gets all available battlepass names
	 */
	public getAllBattlepassNames(): readonly BattlepassName[] {
		return BATTLEPASS_NAMES;
	}

	/**
	 * Tracks analytics when a player views their battlepass progress
	 */
	public async trackBattlepassView(player: Player): Promise<void> {
		try {
			const currentTier = await this.getCurrentTier(player);
			const currentXP = await this.getCurrentXP(player);
			const hasPremium = await this.hasPremium(player);
			const progress = await this.getTierProgress(player);

			this.analytics.LogCustomEvent(player, "battlepass_viewed", 1, {
				battlepass_name: this.getActiveBattlepass(),
				current_tier: tostring(currentTier),
				current_xp: tostring(currentXP),
				tier_progress: tostring(math.floor(progress)),
				has_premium: hasPremium ? "true" : "false",
				max_tier: tostring(this.getMaxTier()),
			});
		} catch (error) {
			warn(`Failed to track battlepass view for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Tracks progression funnel events for battlepass engagement
	 */
	public async trackBattlepassFunnel(
		player: Player,
		step: "view" | "xp_gain" | "tier_unlock" | "reward_claim" | "premium_consider" | "premium_purchase",
	): Promise<void> {
		try {
			const currentTier = await this.getCurrentTier(player);
			const funnelSessionId = `${player.UserId}_${this.getActiveBattlepass()}_${currentTier}`;

			const stepMapping = {
				view: { step: 1, name: "View Battlepass" },
				xp_gain: { step: 2, name: "Gain XP" },
				tier_unlock: { step: 3, name: "Unlock Tier" },
				reward_claim: { step: 4, name: "Claim Reward" },
				premium_consider: { step: 5, name: "Consider Premium" },
				premium_purchase: { step: 6, name: "Purchase Premium" },
			};

			const stepInfo = stepMapping[step];
			this.analytics.LogFunnelStepEvent(
				player,
				"BattlepassProgression",
				funnelSessionId,
				stepInfo.step,
				stepInfo.name,
				{
					battlepass_name: this.getActiveBattlepass(),
					current_tier: tostring(currentTier),
				},
			);
		} catch (error) {
			warn(`Failed to track battlepass funnel for ${player.Name}: ${error}`);
		}
	}
}
