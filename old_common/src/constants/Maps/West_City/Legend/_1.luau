local StoryStage = {}

StoryStage.WaveCount = 15 -- how many waves you need to setup
StoryStage.Boss = "Super Buu"

StoryStage.EnemyPool = { 
	["Flying Alien"] = "Flying Alien",
	["Shielder Alien"] = "Shielder Alien",
	["Alien"] = "Alien", 
	["Guardian Alien"] = "Guardian Alien",
	["Speedster Alien"] = "Speedster Alien",
	["Explosive Alien"] = "Explosive Alien",
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
			["SmallCapsule"] = 	{Amount = NumberRange.new(2,4), Chance = 1, RNG = NumberRange.new(1,1)},
			["LightStone"] = 	{Amount = NumberRange.new(1,3), Chance = 1, RNG = NumberRange.new(1,1)},
			["Halo"] = 	{Amount = NumberRange.new(1,3), Chance = 1, RNG = NumberRange.new(1,1)}
		},

		Units = {},
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
			["TraitCrystal"] = 1	
		},

		Units = {},
	},
}

StoryStage.Star_Missions = {
	[1] = {Name = "BeatStage", Data = {}},
	[2] = {Name = "PlaceAtLeastElement", Data = {Amount = 2, Element = "Light"}} ,
	[3] = {Name = "LimitedTime", Data = {Time = 7}},
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Alien"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Alien"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Alien"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Alien"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Shielder Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool.Alien,
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
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
						EnemyName = StoryStage.EnemyPool.Alien,
						EnemyCount = 15,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Alien"],
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Shielder Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
						EnemyName = StoryStage.EnemyPool["Alien"],
						EnemyCount = 17,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster Alien"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
						}
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Shielder Alien"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Light = NumberRange.new(30, 60), 
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
							Light = NumberRange.new(30, 60), 
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
