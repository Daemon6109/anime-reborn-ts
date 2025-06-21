local StoryStage = {}

StoryStage.DisplayName = "Frozen Outskirts"
StoryStage.ActName = 'Mayhem'
StoryStage.WaveCount = 15 -- how many waves you need to setup
StoryStage.Boss = "Douma"

StoryStage.EnemyPool = { 
	["Flying"] = "Flying Festive Hitman",
	["Shielder"] = "Shielder Festive Hitman",
	["Enemy"] = "Festive Hitman",
	["Guardian"] = "Guardian Festive Hitman",
	["Speedster"] = "Speedster Festive Hitman",
	["Explosive"] = "Explosive Festive Hitman",
	["Regenerator"] = "Regenerator Festive Hitman",
}

StoryStage.Rewards = {
	Set = {	
		Currencies = {
			--Gems = 30,
			--Gold = 80,
			["Candy Cane"] = 750
		},

		Items = {
				
		},

		Units = {},
	},

	FirstClear = {
		Currencies = {
			--Gems = 25,
		},

		Items = {},

		Units = {},
	},

	["Random"] = {
		Currencies = {

		},

		Items = {
			["RarePresent"] = {Amount = NumberRange.new(1,1), Chance = 68, RNG = NumberRange.new(1,100)},
			["EpicPresent"] = {Amount = NumberRange.new(1,1), Chance = 25, RNG = NumberRange.new(1,100)},
			["LegendaryPresent"] = {Amount = NumberRange.new(1,1), Chance = 5, RNG = NumberRange.new(1,100)},
			["MythicPresent"] = {Amount = NumberRange.new(1,1), Chance = 2, RNG = NumberRange.new(1,100)},
		},

		Units = {
		},
	},
}

StoryStage.Star_Rewards = {
	[1] = {
		Currencies = {
			Gems = 120,
		},

		Items = {},

		Units = {},
	},
	[2] = {
		Currencies = {
			Gems = 120,
		},

		Items = {},

		Units = {},
	},
	[3] = {
		Currencies = {
		},

		Items = {
			["TraitCrystal"] = 2	
		},

		Units = {},
	},
}

StoryStage.Star_Missions = {
	[1] = {Name = "BeatStage", Data = {}},
	[2] = {Name = "PlaceAtLeastElement", Data = {Amount = 3, Element = "Light"}} ,
	[3] = {Name = "SellAtUpgrade", Data = {Amount = 4, Upgrade = 2}},
}

StoryStage.Star_Missions_Nightmare = {
	[1] = {Name = "BeatStage", Data = {}},
	[2] = {Name = "LimitedTimeForFinalWave", Data = {Time = 60}} ,
	[3] = {Name = "LessThanUnits", Data = {Amount = 4}},
}

StoryStage.UnitXPReward = NumberRange.new(500,5000)

StoryStage.Waves = {
	[1] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 10, -- seconds
			}, -- one pack
			[2] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.Boss,
						EnemyCount = 1,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[2] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[3] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[4] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[5] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[6] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[7] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[8] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[9] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[10] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[11] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[12] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		--IsBoss = true,
		AfterWaveEndedDelay = 3, -- seconds until next wave
		--IsLastWave = true
	},
	[13] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		--IsBoss = true,
		AfterWaveEndedDelay = 3, -- seconds until next wave
		--IsLastWave = true
	},
	[14] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		--IsBoss = true,
		AfterWaveEndedDelay = 3, -- seconds until next wave
		--IsLastWave = true
	},
	[15] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
			[2] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.Boss,
						EnemyCount = 1,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		IsBoss = true,
		AfterWaveEndedDelay = 3, -- seconds until next wave
		IsLastWave = true
	},
}

return StoryStage
