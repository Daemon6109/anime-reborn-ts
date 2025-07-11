import battlepass from "@shared/configuration/battlepass-data.json";

export type BattlepassRegistry = typeof battlepass;
export type BattlepassName = keyof BattlepassRegistry;
export type BattlepassData = BattlepassRegistry[BattlepassName];
export type LevelData = BattlepassData["LevelData"];
export type Level = keyof LevelData;
export type RewardData = LevelData[Level];

/**
 * All battlepass data organized by their internal names
 */
export const BattlepassRegistry: BattlepassRegistry = battlepass;

/**
 * Helper functions for working with battlepasses
 */
export namespace BattlepassData {
	/**
	 * Get battlepass data by name
	 */
	export function getBattlepass(name: BattlepassName): BattlepassData | undefined {
		return BattlepassRegistry[name];
	}

	/**
	 * Get the end date of a battlepass
	 */
	export function getEndDate(name: BattlepassName): number[] | undefined {
		return BattlepassRegistry[name]?.EndDate;
	}

	/**
	 * Get the level data for a battlepass
	 */
	export function getLevelData(name: BattlepassName): LevelData | undefined {
		return BattlepassRegistry[name]?.LevelData;
	}

	/**
	 * Get the rewards for a specific level
	 */
	export function getLevelRewards(name: BattlepassName, level: Level): RewardData | undefined {
		return BattlepassRegistry[name]?.LevelData[level];
	}

	/**
	 * Get the experience required for a specific level
	 */
	export function getLevelExp(name: BattlepassName, level: Level): number | undefined {
		return BattlepassRegistry[name]?.LevelData[level]?.Exp;
	}
}
