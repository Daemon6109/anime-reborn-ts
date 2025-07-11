import mapOrder from "@shared/configuration/map-order-data.json";

export type MapOrderRegistry = typeof mapOrder;
export type MapType = keyof MapOrderRegistry;
export type MapOrderData = MapOrderRegistry[MapType];

/**
 * All map order data organized by their internal names
 */
export const MapOrderRegistry: MapOrderRegistry = mapOrder;

/**
 * Helper functions for working with map order data
 */
export namespace MapOrderData {
	/**
	 * Get map order data by map type
	 */
	export function getMapOrder(mapType: MapType): MapOrderData | undefined {
		return MapOrderRegistry[mapType];
	}

	/**
	 * Get the order of a specific map
	 */
	export function getMap(mapType: MapType, mapName: string): number | undefined {
		const mapOrder = MapOrderRegistry[mapType];
		return mapOrder && (mapOrder as Record<string, number>)[mapName];
	}
}
