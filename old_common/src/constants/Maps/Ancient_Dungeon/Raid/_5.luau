local StoryStage = {}

StoryStage.DisplayName = "Dungeon Expedition V"
StoryStage.WaveCount = 20 -- how many waves you need to setup
StoryStage.Boss = "Mercury"
StoryStage.PityNeeded = 80
--StoryStage.Cutscenes = {
--	["Intro"] = "Fujishima Kaido Intro",
--}

StoryStage.EnemyPool = { 
	["Flying"] = "Flying Mage",
	["Shielder"] = "Shielder Mage",
	["Enemy"] = "Mage",
	["Guardian"] = "Guardian Mage",
	["Speedster"] = "Speedster Mage",
	["Explosive"] = "Explosive Mage",
	["Regenerator"] = "Regenerator Mage",
}

local Constants = require(game.ReplicatedStorage.Libs.Constants)

StoryStage.ItemPool = {
	["GrimoirePages"] = {Amount = NumberRange.new(26,32), Chance = 1, RNG = NumberRange.new(1,1)},
	["UniversalRaidToken"] = {Amount = NumberRange.new(26,32), Chance = 1, RNG = NumberRange.new(1,1)},
	["MageStone"] = {Amount = NumberRange.new(2,6), Chance = 1, RNG = NumberRange.new(1,1)}
}
StoryStage.UnitPool = {
	["Mars"] = {Amount = NumberRange.new(1,1), Chance = 10, RNG = NumberRange.new(1,1000)}
}
StoryStage.RandomCurrencyPool = {}

StoryStage.Totems = {
	["MagicNecklace"] = 0.15
}

StoryStage.Rewards = {
	Set = {	
		Currencies = {
			Gems = 50,
			--["Red Ticket"] = 1000,
		},

		Items = {},

		Units = {},
	},

	FirstClear = {
		Currencies = {
			Gold = Constants.FIRST_CLEAR_BONUS_GOLD,
			Gems = 50
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
		Currencies = {},

		Items = {
			["Redstone"] = 2
		},

		Units = {},
	},
	[2] = {
		Currencies = {},

		Items = {
			["FrostKey"] = 2
		},

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
	[2] = {Name = "PlaceAtLeastElement", Data = {Amount = 3, Element = "Wind"}},
	[3] = {Name = "SellAtUpgrade", Data = {Amount = 1, Upgrade = 6}},
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
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .7, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Regenerator"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[6] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[7] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[8] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[9] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[10] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 9,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Enemy"],
						EnemyCount = 11,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[11] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 8,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
	},
	[12] = {
		EnemyPacks = {
			[1] = {
				Enemies = {
					[1] = {
						EnemyName = StoryStage.EnemyPool["Regenerator"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
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
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
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
							EnemyName = StoryStage.EnemyPool["Speedster"],
							EnemyCount = 5,
							PerEnemySpawnDelay = .7, -- seconds
							AsyncSpawn = false,
						}, -- array for ordering
						[2] = {
							EnemyName = StoryStage.EnemyPool["Guardian"],
							EnemyCount = 5,
							PerEnemySpawnDelay = .7, -- seconds
							AsyncSpawn = false,
						}, -- array for ordering
						[3] = {
							EnemyName = StoryStage.EnemyPool["Flying"],
							EnemyCount = 5,
							PerEnemySpawnDelay = .7, -- seconds
							AsyncSpawn = false,
						}, -- array for ordering
						[4] = {
							EnemyName = StoryStage.EnemyPool["Shielder"],
							EnemyCount = 5,
							PerEnemySpawnDelay = .7, -- seconds
							AsyncSpawn = false,
						}, -- array for ordering
						[5] = {
							EnemyName = StoryStage.EnemyPool["Explosive"],
							EnemyCount = 5,
							PerEnemySpawnDelay = .7, -- seconds
							AsyncSpawn = false,
						}, -- array for ordering
						[6] = {
							EnemyName = StoryStage.EnemyPool["Regenerator"],
							EnemyCount = 5,
							PerEnemySpawnDelay = .7, -- seconds
							AsyncSpawn = false,
						}, -- array for ordering
					},
					AfterPackSpawnedDelay = 0, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 15,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Regenerator"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Regenerator"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 17,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 12,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Shielder"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Explosive"],
						EnemyCount = 7,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[5] = {
						EnemyName = StoryStage.EnemyPool["Regenerator"],
						EnemyCount = 5,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
				},
				AfterPackSpawnedDelay = 0, -- seconds
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
						EnemyName = StoryStage.EnemyPool["Speedster"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[2] = {
						EnemyName = StoryStage.EnemyPool["Guardian"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[3] = {
						EnemyName = StoryStage.EnemyPool["Flying"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[4] = {
						EnemyName = StoryStage.EnemyPool["Regenerator"],
						EnemyCount = 10,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					}, -- array for ordering
					[5] = {
						EnemyName = StoryStage.Boss,
						EnemyCount = 1,
						PerEnemySpawnDelay = .7, -- seconds
						AsyncSpawn = false,
					},
				},
				AfterPackSpawnedDelay = 0, -- seconds
			}, -- one pack
		},
		AfterWaveEndedDelay = 3, -- seconds until next wave
		IsLastWave = true
	},
}

return StoryStage
