local StoryStage = {}

StoryStage.WaveCount = 15 -- how many waves you need to setup
StoryStage.Boss = "Soul Desert [StoryBoss6]"

StoryStage.EnemyPool = { 
	["Flying"] = "Soul Desert [Aerial]",
	["Shielder"] = "Soul Desert [Shield]",
	["Enemy"] = "Soul Desert [Basic]", 
	["Guardian"] = "Soul Desert [Heavy]",
	["Speedster"] = "Soul Desert [Fast]",
	["Explosive"] = "Soul Desert [Basic]",
	["Regenerator"] = "Soul Desert [Basic]",
}

local Constants = require(game.ReplicatedStorage.Libs.Constants)

StoryStage.ItemPool = {}
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

		Items = {
			["Dragon Ball (5)"] = {Amount = NumberRange.new(1,1), Chance = 5, RNG = NumberRange.new(1,100)},
			["MenosMask"] = {Amount = NumberRange.new(4, 6), Chance = 1, RNG = NumberRange.new(1,1)},	
		},

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
	[2] = {Name = "LessThanUnits", Data = {Amount = 10}} ,
	[3] = {Name = "WaveLimitedTime", Data = {Wave = 10, Time = 40}},
}

StoryStage.Star_Missions_Nightmare = {
	[1] = {Name = "BeatStage", Data = {}},
	[2] = {Name = "LessThanUnits", Data = {Amount = 7}} ,
	[3] = {Name = "WaveLimitedTime", Data = {Wave = 10, Time = 30}},
}

StoryStage.UnitXPReward = NumberRange.new(500,5000)

StoryStage.Waves = {
	[1] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
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
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 3,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 2,
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
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 2,
						PerEnemySpawnDelay = 0.7, -- seconds
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
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
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
	[5] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 8,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 4,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
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
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 3,
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
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 20,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
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
	[8] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
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
	[9] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 4,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
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
	[10] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 3,
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
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 8,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 8,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 5,
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
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 7,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 4,
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
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
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
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 5,
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
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 13,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 5,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
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
