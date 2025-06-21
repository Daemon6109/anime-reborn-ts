local InfiniteScenario = {}

InfiniteScenario.Boss = "Dabura"
InfiniteScenario.BossPool = {
	["Kid Buu"] = "Kid Buu",
	["Super Buu"] = "Super Buu",
	["Evil Buu"] = "Evil Buu",
	["Big Buu"] = "Big Buu",
	["Vegeta Majin"] = "Vegeta Majin",
	["Dabura"] = "Dabura",
}

InfiniteScenario.EnemyPool = { 
	["Flying Enemy"] = "Flying Alien",
	["Shielder Enemy"] = "Shielder Alien",
	["Enemy"] = "Alien", 
	["Guardian Enemy"] = "Guardian Alien",
	["Speedster Enemy"] = "Speedster Alien",
	["Explosive Enemy"] = "Explosive Alien",
}

InfiniteScenario.EnemyExtraData = {
	["Enemy"] = {
		Cost = 10,
		StartingFromWave = 1,
		MinAmount = 5,
		MaxAmount = 30
	}, 
	["Guardian Enemy"] = {
		Cost = 25,
		StartingFromWave = 3,
		MinAmount = 3,
		MaxAmount = 30
	}, 
	["Speedster Enemy"] = {
		Cost = 35,
		StartingFromWave = 5,
		MinAmount = 3,
		MaxAmount = 20
	},
	["Flying Enemy"] = {
		Cost = 50,
		StartingFromWave = 5,
		MinAmount = 3,
		MaxAmount = 20
	},
	["Shielder Enemy"] = {
		Cost = 60,
		StartingFromWave = 10,
		MinAmount = 3,
		MaxAmount = 15
	},
	["Explosive Enemy"] = {
		Cost = 75,
		StartingFromWave = 10,
		MinAmount = 2,
		MaxAmount = 10
	},
}

--InfiniteScenario.BossCreditCost = {
--	["Frieza"] = 2000,
--}

InfiniteScenario.Cards = true
InfiniteScenario.CardsRate = 2

InfiniteScenario.StartingCredit = 100
InfiniteScenario.CreditRiseFlat = 25
InfiniteScenario.CreditRisePercent = 1.05
InfiniteScenario.ExtraCreditRisePerUnitPlaced = .5

InfiniteScenario.ExtraCreditRisePerPlayerFlat = 10
InfiniteScenario.ExtraCreditRisePerPlayerPercent = 1.01

InfiniteScenario.MaxCredit = 2500
InfiniteScenario.CreditToHealthRatio = 1000

InfiniteScenario.HealthRiseFlat = .1
InfiniteScenario.HealthRisePercent = 1.02

InfiniteScenario.ExtraHealthRisePerPlayerFlat = .05
InfiniteScenario.ExtraHealthRisePerPlayerPercent = 1.01

InfiniteScenario.BossWave = 10

InfiniteScenario.ElementsStartFromWave = 1
InfiniteScenario.ElementsPerPack = 2
InfiniteScenario.ElementStartingChance = 10 --10%
InfiniteScenario.ElementChanceRisePerWave = 2.5 --2.5%

InfiniteScenario.ElementsWeightPool = {
	Fire = 9,
	Fierce = 1,
}

InfiniteScenario.ElementsPercentRange = {
	Fire = NumberRange.new(-50, 20),
	Fierce = NumberRange.new(-50, 20)
}

InfiniteScenario.WaveTemplate = {
	EnemyPacks = {
		[1] = {
			Enemies = {
				[1] = {
					EnemyName = InfiniteScenario.EnemyPool["Flying Alien"],
					EnemyCount = 7,
					PerEnemySpawnDelay = 1.5, -- seconds
					AsyncSpawn = false,
				}, -- array for ordering
			},
			AfterPackSpawnedDelay = 0, -- seconds
		}, -- one pack
	},
	Notification = nil,
	AfterWaveEndedDelay = 3, -- seconds until next wave
	OnWaveStart = function()
	end,
	OnWaveEnd = function()
	end,
}

InfiniteScenario.Rewards = {
	["Random"] = { --triggers each wave
		Currencies = {
			Gold = {Amount = NumberRange.new(16,16), Chance = 1, RNG = NumberRange.new(1,1)},
			Gems = {Amount = NumberRange.new(7,7), Chance = 1, RNG = NumberRange.new(1,1)}
		},

		Items = {},

		Units = {},
	},
	
	["Packs"] = {
		{
			WaveNum = 10,

			Weights = {
				["RarePresent"] = 68,
				["EpicPresent"] = 25,
				["LegendaryPresent"] = 5,
				["MythicPresent"] = 2,
			},

			Rewards = {
				["RarePresent"] = {Amount = NumberRange.new(1,1), Type = "Items"},
				["EpicPresent"] = {Amount = NumberRange.new(1,1), Type = "Items"},
				["LegendaryPresent"] = {Amount = NumberRange.new(1,1), Type = "Items"},
				["MythicPresent"] = {Amount = NumberRange.new(1,1), Type = "Items"}
			}
		}
	}
}

InfiniteScenario.Star_Rewards = {
	[1] = {
		Currencies = {
		},

		Items = {
			["PotentialKey"] = 10
		},

		Units = {},
	},
	[2] = {
		Currencies = {
		},

		Items = {
			["FrostKey"] = 5	
		},

		Units = {},
	},
	[3] = {
		Currencies = {
		},

		Items = {
			["TraitCrystal"] = 3	
		},

		Units = {},
	},
}

InfiniteScenario.Star_Missions = {
	[1] = {Name = "ReachWave", Data = {Wave = 10}},
	[2] = {Name = "ReachWave", Data = {Wave = 25}},
	[3] = {Name = "ReachWave", Data = {Wave = 50}},
}

return InfiniteScenario
