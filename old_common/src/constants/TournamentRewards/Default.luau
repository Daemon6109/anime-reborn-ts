local module = {}

module.Number = {
	[1] = {
		Requirement = NumberRange.new(1, 1),
		Rewards = {
			Currencies = {
				Gems = 5000,
			},
			Items = {
				TraitCrystal = 50,
				Trophies = 50,
			},
			Units = {},
			ShinyUnits = {},
			Titles = {}
		},
	},
	[2] = {
		Requirement = NumberRange.new(2, 15),
		Rewards = {
			Currencies = {
				Gems = 4000,
			},
			Items = {
				TraitCrystal = 40,
				Trophies = 40,
			},
			Units = {},
			ShinyUnits = {},
		},
	},
}

module.Percent = {
	[1] = {
		Requirement = NumberRange.new(0, 29.99),
		Rewards = {
			Currencies = {
				Gems = 3500,
			},
			Items = {
				TraitCrystal = 35,
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
				Gems = 3000,
			},
			Items = {
				TraitCrystal = 30,
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
				Gems = 2750,
			},
			Items = {
				TraitCrystal = 25,
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
				Gems = 2225,
			},
			Items = {
				TraitCrystal = 20,
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
				Gems = 2000,
			},
			Items = {
				TraitCrystal = 15,
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
				Gems = 1000,
			},
			Items = {
				TraitCrystal = 10,
				Trophies = 10,
			},
			Units = {},
			ShinyUnits = {},
		},
	},
}

setmetatable(module, {__index = require(game:GetService("ReplicatedStorage").Registry.LeaderboardData).Metadata})

return module
