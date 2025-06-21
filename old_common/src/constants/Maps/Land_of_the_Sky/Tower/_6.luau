local StoryStage = {}

StoryStage.WaveCount = 15 -- how many waves you need to setup
StoryStage.Boss = "Enel"

StoryStage.EnemyPool = { 
	["Flying Angel"] = "Flying Angel",
	["Shielder Angel"] = "Shielder Angel",
	["Angel"] = "Angel", 
	["Guardian Angel"] = "Guardian Angel",
	["Speedster Angel"] = "Speedster Angel",
	["Explosive Angel"] = "Explosive Angel",
	["Regenerator Angel"] = "Regenerator Angel",
}

local Constants = require(game.ReplicatedStorage.Libs.Constants)

StoryStage.ItemPool = {--{["Soul"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,1)},
["SkyShell"] = {Amount = NumberRange.new(2,6), Chance = 1, RNG = NumberRange.new(1,1)}}
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
			["TraitCrystal"] = 2
		},

		Units = {},
	},
}

StoryStage.Star_Missions = {
	[1] = {Name = "BeatStage", Data = {}},
	[2] = {Name = "SellAtUpgrade", Data = {Amount = 3, Upgrade = 4}},
	[3] = {Name = "HaveBaseHP", Data = {HP = 1}},
}

StoryStage.Star_Missions_Nightmare = {
	[1] = {Name = "BeatStage", Data = {}},
	[2] = {Name = "SellAtUpgrade", Data = {Amount = 5, Upgrade = 4}},
	[3] = {Name = "HaveBaseHP", Data = {HP = 1}},
}

StoryStage.UnitXPReward = NumberRange.new(500,5000)

StoryStage.Waves = {
	[1] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Angel,
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
	[2] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
						EnemyCount = 1,
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
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
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
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 8,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
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
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
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
	[6] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
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
	[7] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 12,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
						EnemyCount = 5,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		Notification = "Be careful! Shielders incoming!",
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[8] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 15,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
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
	[9] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 15,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
						EnemyCount = 6,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		Notification = "Be careful! Guardians incoming!",
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[10] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 15,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
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
	[11] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 15,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
						EnemyCount = 8,
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
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 12,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
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
	[13] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 12,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
						EnemyCount = 9,
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
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
						EnemyCount = 10,
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
						EnemyName = StoryStage.EnemyPool.Angel,
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Explosive Angel"],
						EnemyCount = 7,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Angel"],
						EnemyCount = 10,
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
