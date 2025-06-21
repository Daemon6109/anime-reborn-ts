return {
	Get = function()
		return {
			Currencies = {
				["Gems"] = { Quantity = math.random(200, 500), Chance = 49 },
				["Candy Cane"] = { Quantity = math.random(200, 500), Chance = 49 },
			},
			Units = {
				["Ragna"] = { Quantity = 1, Chance = 0.75 },
			},
			Items = {
				["RedeemableHoverCar"] = { Quantity = 1, Chance = 0.625 },
				["RedeemableCandySleigh"] = { Quantity = 1, Chance = 0.75 },
			},
		}
	end,
}
