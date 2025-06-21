local StoryStage = {}

StoryStage.WaveCount = 15 -- how many waves you need to setup
StoryStage.Boss = "Queen"

StoryStage.EnemyPool = { 
	["Flying Animal Pirate"] = "Flying Animal Pirate",
	["Shielder Animal Pirate"] = "Shielder Animal Pirate",
	["Animal Pirate"] = "Animal Pirate", 
	["Guardian Animal Pirate"] = "Guardian Animal Pirate",
	["Speedster Animal Pirate"] = "Speedster Animal Pirate",
	["Explosive Animal Pirate"] = "Explosive Animal Pirate",
	["Regenerator Animal Pirate"] = "Regenerator Animal Pirate",
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
			["SmileFruit"] = {Amount = NumberRange.new(2,4), Chance = 1, RNG = NumberRange.new(1,1)},
			["FierceStone"] = {Amount = NumberRange.new(1,3), Chance = 1, RNG = NumberRange.new(1,1)},
			["SpikedClub"] = {Amount = NumberRange.new(1,3), Chance = 1, RNG = NumberRange.new(1,1)}
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
	[2] = {Name = "WaveLimitedTime", Data = {Wave = 12, Time = 30}} ,
	[3] = {Name = "LessThanUnits", Data = {Amount = 4}},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder Animal Pirate"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder Animal Pirate"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 2,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 4,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Animal Pirate"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Animal Pirate"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder Animal Pirate"],
						EnemyCount = 3,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
						EnemyName = StoryStage.EnemyPool["Animal Pirate"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian Animal Pirate"],
						EnemyCount = 6,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator Animal Pirate"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .8, -- seconds
						AsyncSpawn = false,
						Elements = {
							Fierce = NumberRange.new(30, 60), 
						},
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
							Fierce = NumberRange.new(30, 60), 
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
