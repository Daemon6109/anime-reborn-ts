export type EventShopData = {
	Bought: { [string]: boolean },
	[string]: { stock: number }?, -- For items with limited stock
}

local function createEventShopData(): EventShopData
	return {
		Bought = {},
	}
end

return createEventShopData
