-- Compiled with roblox-ts v2.3.0
-- Economy currencies factory
local function createCurrencies()
	return {
		Gold = 0,
		Gems = 500,
		["Red Ticket"] = 0,
		["Candy Cane"] = 0,
		["New Year Coin"] = 0,
	}
end
return {
	createCurrencies = createCurrencies,
}
