export type DungeonShopData = {
	Bought: { [string]: boolean },
	[string]: { stock: number }?, -- For items with limited stock
}

local function createDungeonShopData(): DungeonShopData
	return {
		Bought = {},
	}
end

return createDungeonShopData
