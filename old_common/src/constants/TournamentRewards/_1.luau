local module = {}

module.Number = {
	[1] = {
		Requirement = NumberRange.new(1, 1),
		Rewards = {
			Currencies = {
				Gems = 10000,
			},
			Items = {
				TraitCrystal = 100,
				Trophies = 50,
			},
			Units = {
				--["CaptainKuro"] = 1,
				["Hit"] = 1,
			},
			ShinyUnits = {
				--["CaptainKuro"] = 1,
				["Hit"] = 1,
			},
			Titles = {}
		},
	},
	[2] = {
		Requirement = NumberRange.new(2, 15),
		Rewards = {
			Currencies = {
				Gems = 8000,
			},
			Items = {
				TraitCrystal = 80,
				Trophies = 40,
			},
			Units = {
				--["CaptainKuro"] = 1,
				["Hit"] = 1,
			},
			ShinyUnits = {},
		},
	},
}

module.Percent = {
	[1] = {
		Requirement = NumberRange.new(0, 29.99),
		Rewards = {
			Currencies = {
				Gems = 7000,
			},
			Items = {
				TraitCrystal = 70,
				Trophies = 35,
			},
			Units = {},
			ShinyUnits = {},
		},
	},
	[2] = {
		Requirement = NumberRange.new(30, 49.99),
		Rewards = {
			Currencies = {
				Gems = 6000,
			},
			Items = {
				TraitCrystal = 60,
				Trophies = 30,
			},
			Units = {},
			ShinyUnits = {},
		},
	},
	[3] = {
		Requirement = NumberRange.new(50, 64.99),
		Rewards = {
			Currencies = {
				Gems = 4800,
			},
			Items = {
				TraitCrystal = 50,
				Trophies = 25,
			},
			Units = {},
			ShinyUnits = {},
		},
	},
	[4] = {
		Requirement = NumberRange.new(65, 79.99),
		Rewards = {
			Currencies = {
				Gems = 4400,
			},
			Items = {
				TraitCrystal = 40,
				Trophies = 20,
			},
			Units = {},
			ShinyUnits = {},
		},
	},
	[5] = {
		Requirement = NumberRange.new(80, 89.99),
		Rewards = {
			Currencies = {
				Gems = 4000,
			},
			Items = {
				TraitCrystal = 30,
				Trophies = 15,
			},
			Units = {},
			ShinyUnits = {},
		},
	},
	[6] = {
		Requirement = NumberRange.new(90, 99.99),
		Rewards = {
			Currencies = {
				Gems = 2000,
			},
			Items = {
				TraitCrystal = 20,
				Trophies = 10,
			},
			Units = {},
			ShinyUnits = {},
		},
	},
}

setmetatable(module, {__index = require(game:GetService("ReplicatedStorage").Registry.LeaderboardData).Metadata})

return module
