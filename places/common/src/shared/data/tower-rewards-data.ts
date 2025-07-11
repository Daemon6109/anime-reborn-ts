import towerRewards from "@shared/configuration/tower-rewards-data.json";

export type TowerRewardsRegistry = typeof towerRewards;
export type TowerName = keyof TowerRewardsRegistry;
export type TowerRewardData = TowerRewardsRegistry[TowerName];
export type RewardType = keyof TowerRewardData;
export type Rewards = TowerRewardData[RewardType];

/**
 * All tower rewards organized by their internal names
 */
export const TowerRewardsRegistry: TowerRewardsRegistry = towerRewards;

/**
 * Helper functions for working with tower rewards
 */
export namespace TowerRewardsData {
	/**
	 * Get tower reward data by tower name
	 */
	export function getTowerRewards(name: TowerName): TowerRewardData | undefined {
		return TowerRewardsRegistry[name];
	}

	/**
	 * Get the rewards for a specific reward type
	 */
	export function getRewards(name: TowerName, rewardType: RewardType): Rewards | undefined {
		return TowerRewardsRegistry[name]?.[rewardType];
	}
}
