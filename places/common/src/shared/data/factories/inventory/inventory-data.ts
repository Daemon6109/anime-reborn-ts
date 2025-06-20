// Inventory data factory
export interface ItemData {
	Count: number;
	Cost: number;
}

export interface InventoryData {
	Units: Record<number, unknown>;
	Items: Record<string, ItemData>;
	Titles: Record<number, unknown>;
	Mounts: Record<string, unknown>; // Changed to string keys for mount names
	Skins: Record<number, unknown>;
	MaxUnitStorage: number;
}

export function createInventoryData(): InventoryData {
	return {
		Units: {},
		Items: {},
		Titles: {},
		Mounts: {},
		Skins: {},
		MaxUnitStorage: 100,
	};
}
