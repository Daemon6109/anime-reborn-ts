import teamEventShopItems from "@shared/configuration/team-event-shop-items-data.json";

export type TeamEventShopItemsRegistry = typeof teamEventShopItems;
export type TeamEventShopItemName = keyof TeamEventShopItemsRegistry;
export type TeamEventShopItemData = TeamEventShopItemsRegistry[TeamEventShopItemName];

/**
 * All team event shop items organized by their internal names
 */
export const TeamEventShopItemsRegistry: TeamEventShopItemsRegistry = teamEventShopItems;

/**
 * Helper functions for working with team event shop items
 */
export namespace TeamEventShopItemsData {
	/**
	 * Get team event shop item data by name
	 */
	export function getTeamEventShopItem(name: TeamEventShopItemName): TeamEventShopItemData | undefined {
		return TeamEventShopItemsRegistry[name];
	}

	/**
	 * Get the price of a team event shop item
	 */
	export function getPrice(name: TeamEventShopItemName): number | undefined {
		return TeamEventShopItemsRegistry[name]?.Price;
	}

	/**
	 * Get the layout order of a team event shop item
	 */
	export function getLayoutOrder(name: TeamEventShopItemName): number | undefined {
		return TeamEventShopItemsRegistry[name]?.LayoutOrder;
	}
}
