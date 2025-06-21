type ItemData = {
	Count: number,
	Cost: number,
}

export type InventoryData = {
	Units: { [number]: any },
	Items: { [string]: ItemData },
	Titles: { [number]: any },
	Mounts: { [string]: any }, -- Changed to string keys for mount names
	Skins: { [number]: any },
	MaxUnitStorage: number,
}

local function createInventoryData(): InventoryData
	return {
		Units = {},
		Items = {},
		Titles = {},
		Mounts = {},
		Skins = {},
		MaxUnitStorage = 100,
	}
end

return createInventoryData
