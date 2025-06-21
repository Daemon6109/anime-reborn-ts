return {
	Get = function()
		return {
			Currencies = {
				["Gems"] = { Quantity = math.random(100, 300), Chance = 4.98 },
			},
			Units = {
				["Boa"] = { Quantity = 1, Chance = 0.01 },
			},
			Skins = {
				["Beast Of Love Gohun"] = { Quantity = 1, Chance = 0.01 },
				["Kirillin Tuxedo"] = { Quantity = 1, Chance = 40 }, -- rare
				["Ten Ten Tuxedo"] = { Quantity = 1, Chance = 40 }, -- rare
				["Emilia Tuxedo"] = { Quantity = 1, Chance = 5 }, -- rare/epic
				["Inosuke Tuxedo"] = { Quantity = 1, Chance = 5 }, -- epic
				["Nezuko Tuxedo"] = { Quantity = 1, Chance = 5 }, -- epic
			},
		}
	end,
}
