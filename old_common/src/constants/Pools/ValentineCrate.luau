return {
	Get = function()
		return {
			Units = {

				["Kirillin"] = { Quantity = 1, Chance = 42.195 }, -- Rare
				["Ten Ten"] = { Quantity = 1, Chance = 41.32 }, -- Rare

				["Inosuke"] = { Quantity = 1, Chance = 5.125 }, -- Epic
				["Nezuko"] = { Quantity = 1, Chance = 5.125 }, -- Epic
				["Emilia"] = { Quantity = 1, Chance = 5.125 }, -- Epic

				["Juvia"] = { Quantity = 1, Chance = 1 }, -- Legendary

				["Funny Valentine"] = { Quantity = 1, Chance = 0.1 }, -- Mythical

				["Rias"] = { Quantity = 1, Chance = 0.05 }, -- Secret
			},
		}
	end,
	SellInfo = { "Gems", 25 },

	Pity = {

		SecretPity = {
			Get = function()
				return {
					["Rias"] = 1,
				}
			end,
			Cost = 4_000,
		},

		MythicalPity = {
			Get = function()
				return {
					["Funny Valentine"] = 1,
				}
			end,
			Cost = 1_000,
		},

		LegendaryPity = {
			Get = function()
				return {
					["Juvia"] = 1,
				}
			end,
			Cost = 100,
		},
	},
}
