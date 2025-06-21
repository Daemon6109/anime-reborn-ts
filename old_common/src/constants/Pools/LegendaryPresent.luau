return {
	Get = function()
		return {
			Items = {
				["RainbowStar"] = { Quantity = 1, Chance = 5 },
				["FrostKey"] = { Quantity = 1, Chance = 23.5 },
				["PotentialKey"] = { Quantity = 1, Chance = 23.5 },
				["RedeemableIceSkates"] = { Quantity = 1, Chance = 1 },
			},
			Currencies = {
				["Candy Cane"] = { Quantity = math.random(350, 500), Chance = 45 },
				["Gems"] = { Quantity = math.random(100, 150), Chance = 2 },
			},
		}
	end,
}
