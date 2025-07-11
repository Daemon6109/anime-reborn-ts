import pools from "@shared/configuration/pools-data.json";

export type PoolsRegistry = typeof pools;
export type PoolName = keyof PoolsRegistry;
export type PoolData = PoolsRegistry[PoolName];

/**
 * All pools organized by their internal names
 */
export const PoolsRegistry: PoolsRegistry = pools;

/**
 * Helper functions for working with pools
 */
export namespace PoolsData {
	/**
	 * Get pool data by name
	 */
	export function getPool(name: PoolName): PoolData | undefined {
		return PoolsRegistry[name];
	}
}
