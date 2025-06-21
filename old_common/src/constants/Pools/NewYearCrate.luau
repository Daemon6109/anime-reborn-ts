return {
	Get = function()
		return {
			Units = {
				["Yamcha"] = { Quantity = 1, Chance = 88.55 },

				["Arlong"] = { Quantity = 1, Chance = 10.25 / 2 },
				["Nezuko"] = { Quantity = 1, Chance = 10.25 / 2 },

				["Orochimaru"] = { Quantity = 1, Chance = 1 },

				["Grimmjow"] = { Quantity = 1, Chance = 0.2 },

				["Beerus"] = { Quantity = 1, Chance = 0.025 },
				["Aizen"] = { Quantity = 1, Chance = 0.025 },

				["Cid"] = { Quantity = 1, Chance = 0.01 },
			},
		}
	end,
	SellInfo = { "New Year Coin", 25 },

	Pity = {

		ExclusivePity = {
			Get = function()
				return {
					["Cid"] = 0.01,
				}
			end,
			Cost = 2_000,
		},

		SecretPity = {
			Get = function()
				return {
					["Beerus"] = 0.05,
					["Aizen"] = 0.05,
				}
			end,
			Cost = 1_800,
		},

		MythicalPity = {
			Get = function()
				return {
					["Grimmjow"] = 0.2,
				}
			end,
			Cost = 400,
		},

		LegendaryPity = {
			Get = function()
				return {
					["Orochimaru"] = 1,
				}
			end,
			Cost = 50,
		},
	},
}
