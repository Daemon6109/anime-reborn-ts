import difficulties from "@shared/configuration/difficulties.json";

export type DifficultiesRegistry = typeof difficulties;
export type DifficultyName = keyof DifficultiesRegistry;
export type DifficultyData = DifficultiesRegistry[DifficultyName];

/**
 * All difficulties organized by their internal names
 */
export const DifficultiesRegistry: DifficultiesRegistry = difficulties;

/**
 * Helper functions for working with difficulties
 */
export namespace DifficultiesData {
	/**
	 * Get difficulty data by name
	 */
	export function getDifficulty(name: DifficultyName): DifficultyData | undefined {
		return DifficultiesRegistry[name];
	}

	/**
	 * Get the icon for a specific difficulty
	 */
	export function getIcon(name: DifficultyName): string | undefined {
		return DifficultiesRegistry[name]?.Icon;
	}
}
