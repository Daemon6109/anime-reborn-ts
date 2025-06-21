local InfiniteScenario = {}

InfiniteScenario.Boss = "Douma"
InfiniteScenario.BossPool = {
	["Douma"] = "Douma",
}

InfiniteScenario.EnemyPool = {
	["Flying Enemy"] = "Flying Festive Hitman",
	["Shielder Enemy"] = "Shielder Festive Hitman",
	["Enemy"] = "Festive Hitman",
	["Guardian Enemy"] = "Guardian Festive Hitman",
	["Speedster Enemy"] = "Speedster Festive Hitman",
	["Explosive Enemy"] = "Explosive Festive Hitman",
	["Regenerator Enemy"] = "Regenerator Festive Hitman",
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
	["Regenerator Enemy"] = {
		Cost = 55,
		StartingFromWave = 7,
		MinAmount = 2,
		MaxAmount = 15
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
InfiniteScenario.CardsRate = 15

InfiniteScenario.StartingCredit = 100
InfiniteScenario.CreditRiseFlat = 25
InfiniteScenario.CreditRisePercent = 1.05
InfiniteScenario.ExtraCreditRisePerUnitPlaced = .5

InfiniteScenario.ExtraCreditRisePerPlayerFlat = 10
InfiniteScenario.ExtraCreditRisePerPlayerPercent = 1.005

InfiniteScenario.MaxCredit = 2500
InfiniteScenario.CreditToHealthRatio = 1000

InfiniteScenario.HealthRiseFlat = .1
InfiniteScenario.HealthRisePercent = 1.02

InfiniteScenario.ExtraHealthRisePerPlayerFlat = .05
InfiniteScenario.ExtraHealthRisePerPlayerPercent = 1.005

InfiniteScenario.BossWave = 10

InfiniteScenario.ElementsStartFromWave = 21
InfiniteScenario.ElementsPerPack = 3
InfiniteScenario.ElementStartingChance = 10 --10%
InfiniteScenario.ElementChanceRisePerWave = 2 --2%

InfiniteScenario.ElementsWeightPool = {
	Fire = 1,
	Fierce = 1,
	Dark = 1,
	Ice = 1,
	Light = 1,
	Water = 1,
	Wind = 1.
}

InfiniteScenario.ElementsPercentRange = {
	Fire = NumberRange.new(-50, -25),
	Fierce = NumberRange.new(-50, -25),
	Dark = NumberRange.new(-50, -25),
	Ice = NumberRange.new(-50, -25),
	Light = NumberRange.new(-50, -25),
	Water = NumberRange.new(-50, -25),
	Wind = NumberRange.new(-50, -25),
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
			--Gold = {Amount = NumberRange.new(20,20), Chance = 1, RNG = NumberRange.new(1,1)},
			--Gems = {Amount = NumberRange.new(10,10), Chance = 1, RNG = NumberRange.new(1,1)}
			["Candy Cane"] = {Amount = NumberRange.new(1000,1000), Chance = 1, RNG = NumberRange.new(1,1), WaveNum = 10}
		},

		Items = {
			["RarePresent"] = {Amount = NumberRange.new(1,1), Chance = 68, RNG = NumberRange.new(1,100), Visual = true},
			["EpicPresent"] = {Amount = NumberRange.new(1,1), Chance = 25, RNG = NumberRange.new(1,100), Visual = true},
			["LegendaryPresent"] = {Amount = NumberRange.new(1,1), Chance = 5, RNG = NumberRange.new(1,100), Visual = true},
			["MythicPresent"] = {Amount = NumberRange.new(1,1), Chance = 2, RNG = NumberRange.new(1,100), Visual = true},
			--["Soul"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,1), WaveNum = 15},
		},

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
