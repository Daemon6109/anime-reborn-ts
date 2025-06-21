local StoryStage = {}

StoryStage.DisplayName = "Beast Hunt"
StoryStage.WaveCount = 25 -- how many waves you need to setup
StoryStage.Boss = "Insect Maximum"
--StoryStage.Cutscenes = {
--	["Intro"] = "Fujishima Kaido Intro",
--}

StoryStage.EnemyPool = { 
	["Flying Red Soldier"] = "Burned York [Aerial]",
	["Shielder Red Soldier"] = "Burned York [Enemy]",
	["Red Soldier"] = "Burned York [Basic]",
	["Guardian Red Soldier"] = "Burned York [Enemy]",
	["Speedster Red Soldier"] = "Burned York [Speedy]",
	["Explosive Red Soldier"] = "Burned York [Explosive]",
	["Regenerator Red Soldier"] = "Burned York [Regenerator]",
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
			["Red Ticket"] = 1000,
		},

		Items = {},

		Units = {},
	},

	FirstClear = {
		Currencies = {},

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
	[2] = {Name = "LessThanUnits", Data = {Amount = 6}},
	[3] = {Name = "PlaceOnlyElements", Data = {Element = "Fire"}},
}

StoryStage.Star_Missions_Nightmare = {
	[1] = {Name = "BeatStage", Data = {}},
	[2] = {Name = "LessThanUnits", Data = {Amount = 6}},
	[3] = {Name = "PlaceOnlyElements", Data = {Element = "Light"}},
}

StoryStage.UnitXPReward = NumberRange.new(500,5000)

StoryStage.Waves = {
	[1] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 7,
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Explosive Red Soldier"],
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Red Soldier"],
						EnemyCount = 5,
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Red Soldier"],
						EnemyCount = 5,
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Red Soldier"],
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
	[6] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying Red Soldier"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Red Soldier"],
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Explosive Red Soldier"],
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Red Soldier"],
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
	[10] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[5] = {
						EnemyName = "Delta 1",
						EnemyCount = 1,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		BossName = "Delta 1",
		IsBoss = true,
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[11] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying Red Soldier"],
						EnemyCount = 2,
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Red Soldier"],
						EnemyCount = 3,
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
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
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Flying Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[5] = {
						EnemyName = StoryStage.EnemyPool["Explosive Red Soldier"],
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
	[16] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Red Soldier"],
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
	[17] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 3,
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
	[18] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying Red Soldier"],
						EnemyCount = 3,
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
	[19] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Flying Red Soldier"],
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
	[20] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder Red Soldier"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Red Soldier"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = "Delta 2",
						EnemyCount = 1,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		BossName = "Delta 2",
		IsBoss = true,
		AfterWaveEndedDelay = 3, -- seconds until next wave
		--IsLastWave = true
	},
	[21] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 7,
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
	[22] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Flying Red Soldier"],
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
	[23] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Red Soldier"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Explosive Red Soldier"],
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
	[24] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Explosive Red Soldier"],
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
	[25] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Red Soldier"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Red Soldier"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian Red Soldier"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Flying Red Soldier"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[5] = {
						EnemyName = StoryStage.EnemyPool["Shielder Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[6] = {
						EnemyName = StoryStage.EnemyPool["Explosive Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[7] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Red Soldier"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[8] = {
						EnemyName = "Insect Maximum", --"Cell Maximum",
						EnemyCount = 1,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 1.5, -- seconds
			}, -- one pack
		},
		BossName = "Insect Maximum",
		IsBoss = true,
		AfterWaveEndedDelay = 3, -- seconds until next wave
		IsLastWave = true
	},
}

return StoryStage
