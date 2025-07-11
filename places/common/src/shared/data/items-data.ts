import items from "@shared/configuration/items-data.json";

export type ItemsRegistry = typeof items;
export type ItemName = keyof ItemsRegistry;
export type ItemData = ItemsRegistry[ItemName];
export type ItemConfiguration = ItemData["configuration"] & {
	[key: string]: any;
};

/**
 * All items organized by their internal names
 */
export const ItemsRegistry: ItemsRegistry = items;

/**
 * Helper functions for working with items
 */
export namespace ItemsData {
	/**
	 * Get item data by name
	 */
	export function getItem(name: ItemName): ItemData | undefined {
		return ItemsRegistry[name];
	}

	/**
	 * Get all usable items
	 */
	export function getUsableItems(): Record<string, ItemData> {
		const usableItems: Record<string, ItemData> = {};
		for (const [name, item] of pairs(ItemsRegistry)) {
			if ((item.configuration as ItemConfiguration).Usable) {
				usableItems[name as string] = item;
			}
		}
		return usableItems;
	}

	/**
	 * Get all items of a specific rarity
	 */
	export function getItemsByRarity(rarity: string): Record<string, ItemData> {
		const filteredItems: Record<string, ItemData> = {};
		for (const [name, item] of pairs(ItemsRegistry)) {
			if ((item.configuration as ItemConfiguration).Rarity === rarity) {
				filteredItems[name as string] = item;
			}
		}
		return filteredItems;
	}

	/**
	 * Get item display name
	 */
	export function getDisplayName(name: ItemName): string | undefined {
		return (ItemsRegistry[name]?.configuration as ItemConfiguration).DisplayName;
	}

	/**
	 * Get item description
	 */
	export function getDescription(name: ItemName): string | undefined {
		return (ItemsRegistry[name]?.configuration as ItemConfiguration).Description;
	}

	/**
	 * Check if an item is usable
	 */
	export function isUsable(name: ItemName): boolean {
		const item = ItemsRegistry[name];
		return item && "configuration" in item && (item.configuration as ItemConfiguration).Usable === true;
	}

	/**
	 * Get item limit
	 */
	export function getLimit(name: ItemName): number | "inf" | undefined {
		const item = ItemsRegistry[name];
		return item && "Limit" in item ? (item.Limit as number | "inf") : undefined;
	}
}
