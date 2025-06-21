local StoryStage = {}

StoryStage.WaveCount = 15 -- how many waves you need to setup
StoryStage.Boss = "Insect Maximum"

StoryStage.EnemyPool = { 
	["Flying"] = "Flying Red Soldier",
	["Shielder"] = "Shielder Red Soldier",
	["Enemy"] = "Red Soldier", 
	["Guardian"] = "Guardian Red Soldier",
	["Speedster"] = "Speedster Red Soldier",
	["Explosive"] = "Explosive Red Soldier",
	["Regenerator"] = "Regenerator Red Soldier",
}

StoryStage.Rewards = {
	Set = {	
		Currencies = {
			Gems = 30,
			Gold = 80,
		},

		Items = {},

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
			--["Soul"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,1)},
			["SpecialBeam"] = {Amount = NumberRange.new(1,1), Chance = 3, RNG = NumberRange.new(1,100)},
			["BlueBlaster"] = {Amount = NumberRange.new(1,1), Chance = 1, RNG = NumberRange.new(1,20)},
		},

		Units = {
			["Pan"] = {Amount = NumberRange.new(1,1), Chance = 25, RNG = NumberRange.new(1,100)},
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
	[2] = {Name = "SpentOnUnit", Data = {Amount = 15000}} ,
	[3] = {Name = "LimitedTimeForFinalWave", Data = {Time = 35}},
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
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 10, -- seconds
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
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						EnemyName = StoryStage.EnemyPool.Enemy,
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						EnemyName = StoryStage.EnemyPool.Enemy,
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						}
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
						Elements = {
							Light = NumberRange.new(15, 25), 
							Dark = NumberRange.new(-85, -55), 
						},
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
