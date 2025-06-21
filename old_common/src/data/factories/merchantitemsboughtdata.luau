export type MerchantItemsBoughtData = {
	Day: number,
	ItemsBought: { [string]: number },
}

local function createMerchantItemsBoughtData(): MerchantItemsBoughtData
	return {
		Day = 0,
		ItemsBought = {},
	}
end

return createMerchantItemsBoughtData
