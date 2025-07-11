import raidShopItems from "@shared/configuration/raid-shop-items-data.json";

export type RaidShopItemsRegistry = typeof raidShopItems;
export type RaidName = keyof RaidShopItemsRegistry;
export type RaidShopItemsData = RaidShopItemsRegistry[RaidName];

// A generic type for any item in any raid shop.
export type RaidShopItemData = {
	readonly Price: number;
	readonly LayoutOrder: number;
	readonly Quantity?: number;
};

/**
 * All raid shop items organized by their internal names
 */
export const RaidShopItemsRegistry: RaidShopItemsRegistry = raidShopItems;

/**
 * Helper functions for working with raid shop items
 */
export namespace RaidShopItemsData {
	/**
	 * Get raid shop items data by raid name
	 */
	export function getRaidShopItems(name: RaidName): RaidShopItemsData | undefined {
		return RaidShopItemsRegistry[name];
	}

	/**
	 * Get a specific item from a raid shop
	 */
	export function getRaidShopItem(raidName: RaidName, itemName: string): RaidShopItemData | undefined {
		const raid = RaidShopItemsRegistry[raidName];
		if (raid && itemName in raid) {
			return (raid as Record<string, RaidShopItemData>)[itemName];
		}
		return undefined;
	}

	/**
	 * Get the price of a specific item in a raid shop
	 */
	export function getPrice(raidName: RaidName, itemName: string): number | undefined {
		const item = getRaidShopItem(raidName, itemName);
		return item?.Price;
	}

	/**
	 * Get the layout order of a specific item in a raid shop
	 */
	export function getLayoutOrder(raidName: RaidName, itemName: string): number | undefined {
		const item = getRaidShopItem(raidName, itemName);
		return item?.LayoutOrder;
	}

	/**
	 * Get the quantity of a specific item in a raid shop
	 */
	export function getQuantity(raidName: RaidName, itemName: string): number | undefined {
		const item = getRaidShopItem(raidName, itemName);
		return item?.Quantity;
	}
}
