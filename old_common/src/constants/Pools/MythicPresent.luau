return {
	Get = function()
		return {
			Units = {
				["Douma"] = { Quantity = 1, Chance = 5 },
				["Saber Alter"] = { Quantity = 1, Chance = 5 },
			},
			Items = {
				["TraitCrystal"] = { Quantity = 1, Chance = 43 },
				["RedeemableCandyCaneBroomstick"] = { Quantity = 1, Chance = 1 },
				["RedeemableCandyHoverboard"] = { Quantity = 1, Chance = 3 },
			},
			Currencies = {
				["Candy Cane"] = { Quantity = math.random(500, 1000), Chance = 43 },
			},
		}
	end,
}
