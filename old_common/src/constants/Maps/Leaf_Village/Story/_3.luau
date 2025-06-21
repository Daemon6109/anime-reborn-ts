local StoryStage = {}

StoryStage.WaveCount = 15 -- how many waves you need to setup
StoryStage.Boss = "Tayuya"

StoryStage.EnemyPool = { 
	["Flying Ninja"] = "Flying Ninja",
	["Shielder Ninja"] = "Shielder Ninja",
	["Ninja"] = "Ninja", 
	["Guardian Ninja"] = "Guardian Ninja",
	["Speedster Ninja"] = "Speedster Ninja",
	["Explosive Ninja"] = "Explosive Ninja",
}

local Constants = require(game.ReplicatedStorage.Libs.Constants)

StoryStage.ItemPool = {--{["Soul"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,1)},
["Naruto"] = {Amount = NumberRange.new(1,5), Chance = 1, RNG = NumberRange.new(1,1)}}
StoryStage.UnitPool = {}
StoryStage.RandomCurrencyPool = {}

StoryStage.Rewards = {
	Set = {	
		Currencies = {
			Gold = Constants.BASE_GOLD_REWARD,
			Gems = Constants.BASE_GEM_REWARD,
		},

		Items = {},

		Units = {},
	},

	FirstClear = {
		Currencies = {
			Gold = Constants.FIRST_CLEAR_BONUS_GOLD,
			Gems = Constants.FIRST_CLEAR_BONUS_GEMS,
		},

		Items = {},

		Units = {},
	},

	["Random"] = {
		Currencies = StoryStage.RandomCurrencyPool,

		Items = StoryStage.ItemPool,

		Units = StoryStage.UnitPool,
	},
}

StoryStage.Star_Rewards = {
	[1] = {
		Currencies = {
			Gems = 60,
		},

		Items = {},

		Units = {},
	},
	[2] = {
		Currencies = {
			Gems = 60,
		},

		Items = {},

		Units = {},
	},
	[3] = {
		Currencies = {},

		Items = {
			["TraitCrystal"] = 1
		},

		Units = {},
	},
}

StoryStage.Star_Missions = {
	[1] = {Name = "BeatStage", Data = {}},
	[2] = {Name = "Damage", Data = {Amount = 25000}} ,
	[3] = {Name = "PlaceAtLeastElement", Data = {Amount = 2, Element = "Fire"}} ,
}

StoryStage.Star_Missions_Nightmare = {
	[1] = {Name = "BeatStage", Data = {}},
	[2] = {Name = "Damage", Data = {Amount = 35000}} ,
	[3] = {Name = "PlaceAtLeastElement", Data = {Amount = 4, Element = "Fire"}} ,
}

StoryStage.UnitXPReward = NumberRange.new(500,5000)

StoryStage.Waves = {
	[1] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 3,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 4,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Ninja"],
						EnemyCount = 2,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		Notification = "Speedsters incoming!",
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[4] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 8,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Ninja"],
						EnemyCount = 2,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		Notification = "Be careful! Guardians incoming!",
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[5] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 8,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Ninja"],
						EnemyCount = 2,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Ninja"],
						EnemyCount = 2,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 12,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Ninja"],
						EnemyCount = 2,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Speedster Ninja"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Ninja"],
						EnemyCount = 4,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 7,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Ninja"],
						EnemyCount = 4,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Ninja"],
						EnemyCount = 4,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Ninja"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Ninja"],
						EnemyCount = 4,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Guardian Ninja"],
						EnemyCount = 4,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = true,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Ninja"],
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Explosive Ninja"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Ninja"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 8,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Ninja"],
						EnemyCount = 8,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Ninja"],
						EnemyCount = 3,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 12,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Ninja"],
						EnemyCount = 8,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						EnemyName = StoryStage.EnemyPool.Ninja,
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Ninja"],
						EnemyCount = 5,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Ninja"],
						EnemyCount = 5,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						PerEnemySpawnDelay = 0.7, -- seconds
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
