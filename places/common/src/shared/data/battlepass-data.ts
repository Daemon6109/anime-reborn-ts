// Configuration
import battlepassDataRaw from "@shared/configuration/battlepass-data.json";

// Performance-optimized exact typing from JSON
export const battlepassData = battlepassDataRaw as typeof battlepassDataRaw;

// Extract actual battlepass names as literal union type from the JSON
export type BattlepassName = keyof typeof battlepassData;

// Exact types - these give you perfect per-battlepass typing
export type ExactBattlepassConfig<T extends BattlepassName> = (typeof battlepassData)[T];
export type ExactLevelData<T extends BattlepassName> = (typeof battlepassData)[T]["LevelData"];
export type ExactLevelReward<T extends BattlepassName, L extends keyof ExactLevelData<T>> = ExactLevelData<T>[L];

// Extract all level numbers from all battlepasses
export type BattlepassLevel = {
	[K in BattlepassName]: keyof ExactLevelData<K>;
}[BattlepassName];

// Create a constant array of battlepass names for runtime use
export const BATTLEPASS_NAMES = (() => {
	const battlepassNames: BattlepassName[] = [];

	// Extract all battlepass names from the configuration
	for (const [battlepassName] of pairs(battlepassData)) {
		battlepassNames.push(battlepassName);
	}

	return battlepassNames as readonly BattlepassName[];
})();

// Create a function to get battlepass by name with exact typing
export function getExactBattlepass<T extends BattlepassName>(name: T): ExactBattlepassConfig<T> | undefined {
	return battlepassData[name];
}

// Get specific battlepass's level data with exact typing
export function getExactLevelData<T extends BattlepassName>(battlepassName: T): ExactLevelData<T> {
	return battlepassData[battlepassName].LevelData;
}

// Get specific level's reward data with exact typing
export function getExactLevelReward<T extends BattlepassName, L extends keyof ExactLevelData<T>>(
	battlepassName: T,
	level: L,
): ExactLevelReward<T, L> | undefined {
	const levelData = battlepassData[battlepassName].LevelData;
	// Use index access with proper type assertion
	return (levelData as Record<string, unknown>)[level as string] as ExactLevelReward<T, L> | undefined;
}

// Extract reward types from the JSON structure
export type BattlepassRewardType = "Regular" | "Premium";

// Extract all possible reward categories from the JSON
type ExtractRewardCategories<T> = T extends { Regular?: infer R }
	? R extends Record<string, unknown>
		? keyof R
		: never
	: never;

export type RewardCategory = ExtractRewardCategories<ExactLevelReward<BattlepassName, BattlepassLevel>>;

// Interface that matches the JSON structure exactly
export interface BattlepassReward {
	Gold?: number;
	Gems?: number;
	Items?: Record<string, number>;
	Units?: Record<string, number>;
	ShinyUnits?: Record<string, number>;
	Currencies?: Record<string, number>;
	Titles?: string[];
}

export interface BattlepassLevelData {
	Regular?: BattlepassReward;
	Premium?: BattlepassReward;
	Exp: number;
}

export interface BattlepassConfig {
	EasyMaxLevel: number;
	EasyMultiplier: number;
	HardExponent: number;
	EndDate: number[]; // Array that should contain [year, month, day]
	LevelData: Record<string, BattlepassLevelData>;
}

/**
 * Helper functions for working with battlepasses
 */
export namespace BattlepassData {
	/**
	 * Get battlepass data by name
	 */
	export function getBattlepass(name: BattlepassName): BattlepassConfig | undefined {
		return battlepassData[name];
	}

	/**
	 * Get the end date of a battlepass
	 */
	export function getEndDate(name: BattlepassName): number[] | undefined {
		return battlepassData[name]?.EndDate;
	}

	/**
	 * Get the level data for a battlepass
	 */
	export function getLevelData(name: BattlepassName): Record<string, BattlepassLevelData> | undefined {
		return battlepassData[name]?.LevelData;
	}

	/**
	 * Get the rewards for a specific level
	 */
	export function getLevelRewards(name: BattlepassName, level: BattlepassLevel): BattlepassLevelData | undefined {
		const levelData = battlepassData[name]?.LevelData;
		return (levelData as Record<string, BattlepassLevelData> | undefined)?.[level as string];
	}

	/**
	 * Get the experience required for a specific level
	 */
	export function getLevelExp(name: BattlepassName, level: BattlepassLevel): number | undefined {
		const levelData = battlepassData[name]?.LevelData;
		return (levelData as Record<string, BattlepassLevelData> | undefined)?.[level as string]?.Exp;
	}
}

import type { Source } from "@rbxts/vide";

export interface BattlepassDataForPlayer {
	level: number;
	xp: number;
	premium: boolean;
	claimed: Map<number, { basic: boolean; premium: boolean }>;
}

export interface PlayerDataBattlepass {
	level: {
		value: Source<number>;
		required: Source<number>;
		current: Source<number>;
	};
	premium: Source<boolean>;
	claimed: Array<{ basic: Source<boolean>; premium: Source<boolean> }>;
}
