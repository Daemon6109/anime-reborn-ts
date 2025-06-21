local StoryStage = {}

StoryStage.WaveCount = 15 -- how many waves you need to setup
StoryStage.Boss = "Kid Buu"

StoryStage.EnemyPool = { 
	["Flying Alien"] = "Flying Alien",
	["Shielder Alien"] = "Shielder Alien",
	["Alien"] = "Alien", 
	["Guardian Alien"] = "Guardian Alien",
	["Speedster Alien"] = "Speedster Alien",
	["Explosive Alien"] = "Explosive Alien",
	["Regenerator Alien"] = "Regenerator Alien",
}

StoryStage.Rewards = {
	Set = {	
		Currencies = {
			Gold = 100,
		},

		Items = {},

		Units = {},
	},

	FirstClear = {
		Currencies = {
			Gems = 25,
		},

		Items = {},

		Units = {},
	},

	["Random"] = {
		Currencies = {
			Gold = {Amount = NumberRange.new(20,50), Chance = 1, RNG = NumberRange.new(1,1)},
		},

		Items = {
			["TraitCrystal"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,1)}
		},

		Units = {
			["Zoro [PTS]"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,1)},
		},
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
	[1] = {Name = "HaveBaseHP", Data = {HP = .8}},
	[2] = {Name = "Eliminations", Data = {Amount = 2}},
	[3] = {Name = "LessThanUnits", Data = {Amount = 4}},
}

StoryStage.Star_Missions_Nightmare = {
	[1] = {Name = "PlaceAtLeastElement", Data = {Element = "Wind", Amount = 3}},
	[2] = {Name = "LimitedTimeForFinalWave", Data = {Time = "2"}},
	[3] = {Name = "PlaceOnlyType", Data = {Type = "Ground"}},
}

StoryStage.UnitXPReward = NumberRange.new(500,5000)

StoryStage.Waves = {
	[1] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Alien"],
						EnemyCount = 20,
						PerEnemySpawnDelay = 2, -- seconds
						AsyncSpawn = false,
						Elements = {Fire = NumberRange.new(30, 50), Wind = NumberRange.new(-50,-30)}
					}, -- array for ordering
					--[2] = {
					--	EnemyName = StoryStage.EnemyPool["Alien"],
					--	EnemyCount = 40,
					--	PerEnemySpawnDelay = .05, -- seconds
					--	AsyncSpawn = false,
					--}, -- array for ordering+
					--[3] = {
					--	EnemyName = StoryStage.EnemyPool.Alien,
					--	EnemyCount = 50,
					--	PerEnemySpawnDelay = .05, -- seconds
					--	AsyncSpawn = false,
					--}, -- array for ordering+
				},
				AfterPackSpawnedDelay = 4, -- seconds
			}, -- one pack
			[2] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Alien,
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool.Alien,
						EnemyCount = 10,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering+
				},
				AfterPackSpawnedDelay = 20, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[2] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool.Alien,
						EnemyCount = 5,
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
						EnemyName = StoryStage.EnemyPool.Alien,
						EnemyCount = 3,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 1,
						PerEnemySpawnDelay = 0.7, -- seconds
						AsyncSpawn = true,
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
						EnemyName = StoryStage.EnemyPool.Alien,
						EnemyCount = 5,
						PerEnemySpawnDelay = .5, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 1,
						PerEnemySpawnDelay = 1.5, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	--[5] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--	},
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--},
	--[6] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 7,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--	},
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--},
	--[7] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 7,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--		[2] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool["Shielder Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 0, -- seconds
	--		}, -- one pack
	--	},
	--	Notification = "Be careful! Shielders incoming!",
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--},
	--[8] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 10,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--		[2] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool["Shielder Alien"],
	--					EnemyCount = 4,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 0, -- seconds
	--		}, -- one pack
	--	},
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--},
	--[9] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 10,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--		[2] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool["Guardian Alien"],
	--					EnemyCount = 1,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Shielder Alien"],
	--					EnemyCount = 2,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 0, -- seconds
	--		}, -- one pack
	--	},
	--	Notification = "Be careful! Guardians incoming!",
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--},
	--[10] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 10,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--		[2] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool["Guardian Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Shielder Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 0, -- seconds
	--		}, -- one pack
	--	},
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--},
	--[11] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 10,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 6,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--		[2] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool["Shielder Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 0, -- seconds
	--		}, -- one pack
	--	},
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--},
	--[12] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 12,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--		[2] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool["Guardian Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 0, -- seconds
	--		}, -- one pack
	--	},
	--	--IsBoss = true,
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--	--IsLastWave = true
	--},
	--[13] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 15,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--		[2] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool["Guardian Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Shielder Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 0, -- seconds
	--		}, -- one pack
	--	},
	--	--IsBoss = true,
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--	--IsLastWave = true
	--},
	--[14] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 15,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 10,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--		[2] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool["Guardian Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Shielder Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 0, -- seconds
	--		}, -- one pack
	--	},
	--	--IsBoss = true,
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--	--IsLastWave = true
	--},
	--[15] = {
	--	EnemyPacks = {
	--		[1] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool.Alien,
	--					EnemyCount = 15,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Speedster Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 1.5, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 1.5, -- seconds
	--		}, -- one pack
	--		[2] = {
	--			Enemies = {
	--				[1] = {
	--					EnemyName = StoryStage.EnemyPool["Guardian Alien"],
	--					EnemyCount = 5,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[2] = {
	--					EnemyName = StoryStage.EnemyPool["Shielder Alien"],
	--					EnemyCount = 3,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--				[3] = {
	--					EnemyName = StoryStage.Boss,
	--					EnemyCount = 1,
	--					PerEnemySpawnDelay = 0.7, -- seconds
	--					AsyncSpawn = false,
	--				}, -- array for ordering
	--			},
	--			AfterPackSpawnedDelay = 0, -- seconds
	--		}, -- one pack
	--	},
	--	IsBoss = true,
	--	AfterWaveEndedDelay = 3, -- seconds until next wave
	--	IsLastWave = true
	--},
}

return StoryStage
