local InfiniteScenario = {}

InfiniteScenario.Boss = "Posessed Pal"
InfiniteScenario.BossPool = {
	["Posessed Pal"] = "Posessed Pal",
	["Mr. Shrimpy"] = "Mr. Shrimpy",
	["Spiral"] = "Spiral",
	["Spiral Red"] = "Spiral Red",
	["Spiral Green"] = "Spiral Green",
	["Spiral Purple"] = "Spiral Purple",
}

InfiniteScenario.EnemyPool = { 
	["Flying Enemy"] = "Flying Anomaly",
	["Shielder Enemy"] = "Shielder Anomaly",
	["Enemy"] = "Anomaly", 
	["Guardian Enemy"] = "Guardian Anomaly",
	["Speedster Enemy"] = "Speedster Anomaly",
	["Explosive Enemy"] = "Explosive Anomaly",
	["Regenerator Enemy"] = "Regenerator Anomaly",
	["Shade Enemy"] = "Shade Anomaly",
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
	["Shade Enemy"] = {
		Cost = 100,
		StartingFromWave = 10,
		MinAmount = 2,
		MaxAmount = 6
	},
}

--InfiniteScenario.BossCreditCost = {
--	["Frieza"] = 2000,
--}

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
			Gold = {Amount = NumberRange.new(20,20), Chance = 1, RNG = NumberRange.new(1,1)},
			Gems = {Amount = NumberRange.new(10,10), Chance = 1, RNG = NumberRange.new(1,1)}
		},

		Items = {
			--["Soul"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,1), WaveNum = 10},
			["GoldenMarble"] = {Amount = NumberRange.new(1,3), Chance = 1, RNG = NumberRange.new(1,1), WaveNum = 15},
			["T1_GhostPortal"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,5), WaveNum = 5, Notification = "You got the portal!"}
		},

		Units = {},
	},
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
