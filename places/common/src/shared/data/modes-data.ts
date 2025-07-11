import modes from "@shared/configuration/modes-data.json";

export type ModesRegistry = typeof modes;
export type ModeName = keyof ModesRegistry;
export type ModeData = ModesRegistry[ModeName];

/**
 * All modes organized by their internal names
 */
export const ModesRegistry: ModesRegistry = modes;

/**
 * Helper functions for working with modes
 */
export namespace ModesData {
	/**
	 * Get mode data by name
	 */
	export function getMode(name: ModeName): ModeData | undefined {
		return ModesRegistry[name];
	}

	/**
	 * Get the wait time for a specific mode
	 */
	export function getWaitTime(name: ModeName): number | undefined {
		return ModesRegistry[name]?.WaitTime;
	}

	/**
	 * Get the maximum number of players for a specific mode
	 */
	export function getMaximumPlayers(name: ModeName): number | undefined {
		return ModesRegistry[name]?.MaximumPlayers;
	}

	/**
	 * Get the minimum number of players for a specific mode
	 */
	export function getMinimumPlayers(name: ModeName): number | undefined {
		return ModesRegistry[name]?.MinimumPlayers;
	}
}
