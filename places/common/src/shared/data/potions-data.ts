import potions from "@shared/configuration/potions-data.json";

export type PotionsRegistry = typeof potions;
export type PotionName = keyof PotionsRegistry;
export type PotionData = PotionsRegistry[PotionName];
export type PotionRecipe = PotionData["Recipe"];

/**
 * All potions organized by their internal names
 */
export const PotionsRegistry: PotionsRegistry = potions;

/**
 * Helper functions for working with potions
 */
export namespace PotionsData {
	/**
	 * Get potion data by name
	 */
	export function getPotion(name: PotionName): PotionData | undefined {
		return PotionsRegistry[name];
	}

	/**
	 * Get the recipe for a specific potion
	 */
	export function getRecipe(name: PotionName): PotionRecipe | undefined {
		return PotionsRegistry[name]?.Recipe;
	}

	/**
	 * Get the redstone cost for a specific potion
	 */
	export function getRedstoneCost(name: PotionName): number | undefined {
		return PotionsRegistry[name]?.RedstoneCost;
	}

	/**
	 * Get the level requirement for a specific potion
	 */
	export function getLevelRequirement(name: PotionName): number | undefined {
		return PotionsRegistry[name]?.LevelRequirement;
	}

	/**
	 * Get the effect applied by a specific potion
	 */
	export function getApplyEffect(name: PotionName): string | undefined {
		return PotionsRegistry[name]?.ApplyEffect;
	}

	/**
	 * Get the duration of a specific potion
	 */
	export function getDuration(name: PotionName): number | undefined {
		return PotionsRegistry[name]?.Duration;
	}
}
