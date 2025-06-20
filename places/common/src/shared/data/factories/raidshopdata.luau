export type RaidShopData = {
	Bought: { [string]: boolean },
	[string]: { stock: number }?, -- For items with limited stock
}

local function createRaidShopData(): RaidShopData
	return {
		Bought = {},
	}
end

return createRaidShopData
