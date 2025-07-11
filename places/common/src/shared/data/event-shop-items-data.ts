import eventShopItems from "@shared/configuration/event-shop-items-data.json";

export type EventShopItemsRegistry = typeof eventShopItems;
export type EventShopItemName = keyof EventShopItemsRegistry;
export type EventShopItemData = EventShopItemsRegistry[EventShopItemName];

/**
 * All event shop items organized by their internal names
 */
export const EventShopItemsRegistry: EventShopItemsRegistry = eventShopItems;

/**
 * Helper functions for working with event shop items
 */
export namespace EventShopItemsData {
	/**
	 * Get event shop item data by name
	 */
	export function getEventShopItem(name: EventShopItemName): EventShopItemData | undefined {
		return EventShopItemsRegistry[name];
	}

	/**
	 * Get the price of an event shop item
	 */
	export function getPrice(name: EventShopItemName): number | undefined {
		return EventShopItemsRegistry[name]?.Price;
	}

	/**
	 * Get the layout order of an event shop item
	 */
	export function getLayoutOrder(name: EventShopItemName): number | undefined {
		return EventShopItemsRegistry[name]?.LayoutOrder;
	}

	/**
	 * Get the quantity of an event shop item
	 */
	export function getQuantity(name: EventShopItemName): number | undefined {
		const item = EventShopItemsRegistry[name];
		return item && "Quantity" in item ? item.Quantity : undefined;
	}
}
