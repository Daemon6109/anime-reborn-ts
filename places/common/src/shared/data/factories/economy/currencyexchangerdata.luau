export type CurrencyExchangerData = {
	Day: number,
	Exchanged: number,
}

local function createCurrencyExchangerData(): CurrencyExchangerData
	return {
		Day = 0,
		Exchanged = 0,
	}
end

return createCurrencyExchangerData
