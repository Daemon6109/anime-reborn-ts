local HTTP = game:GetService("HttpService")

local SlotbarTemplate = {
	Slot1 = {
		UUID = "",
		UnitName = "",
		Traits = {
			[1] = "",
			[2] = "",
			[3] = "",
		},
		Relic = "",
		Skin = "",
		Level = 1,
		XP = 0,
		AbilityTree = {},
		StatsPotential = {},
		StatsTraining = {},
		Locked = false,
		Shiny = false,
	},
	Slot2 = {
		UUID = "",
		UnitName = "",
		Traits = {
			[1] = "",
			[2] = "",
			[3] = "",
		},
		Relic = "",
		Skin = "",
		Level = 1,
		XP = 0,
		AbilityTree = {},
		StatsPotential = {},
		StatsTraining = {},
		Locked = false,
		Shiny = false,
	},
	Slot3 = {
		UUID = "",
		UnitName = "",
		Traits = {
			[1] = "",
			[2] = "",
			[3] = "",
		},
		Relic = "",
		Skin = "",
		Level = 1,
		XP = 0,
		AbilityTree = {},
		StatsPotential = {},
		StatsTraining = {},
		Locked = false,
		Shiny = false,
	},
	Slot4 = {
		UUID = "",
		UnitName = "",
		Traits = {
			[1] = "",
			[2] = "",
			[3] = "",
		},
		Relic = "",
		Skin = "",
		Level = 1,
		XP = 0,
		AbilityTree = {},
		StatsPotential = {},
		StatsTraining = {},
		Locked = false,
		Shiny = false,
	},
	Slot5 = {
		UUID = "",
		UnitName = "",
		Traits = {
			[1] = "",
			[2] = "",
			[3] = "",
		},
		Relic = "",
		Skin = "",
		Level = 1,
		XP = 0,
		AbilityTree = {},
		StatsPotential = {},
		StatsTraining = {},
		Locked = false,
		Shiny = false,
	},
	Slot6 = {
		UUID = "",
		UnitName = "",
		Traits = {
			[1] = "",
			[2] = "",
			[3] = "",
		},
		Relic = "",
		Skin = "",
		Level = 1,
		XP = 0,
		AbilityTree = {},
		StatsPotential = {},
		StatsTraining = {},
		Locked = false,
		Shiny = false,
	},
}

local CompletedMissionStoryTemplate = {
	["West City"] = {
		[1] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[2] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[3] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[4] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[5] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
		[6] = {
			CompletedTimes = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			FastestTime = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
			Stars = {
				["Normal"] = 0,
				["Nightmare"] = 0,
			},
		},
	},
}

local CompletedMissionRaidTemplate = {
	["Ancient Dungeon"] = {
		[1] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[2] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[3] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[4] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[5] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
		[6] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
			LockData = {
				MaxCompletedTimes = 3,
				CompletedTimes = 0,
				Time = 0,
			},
		},
	},
}

local CompletedMissionInfiniteTemplate = {
	["West City"] = {
		HighestWave = 0,
		Stars = {
			["Infinite"] = 0,
		},
	},
}

local CompletedMissionDungeonTemplate = {
	["Dorasoza (Destroyed)"] = {
		[1] = {
			CompletedTimes = {
				["Raid"] = 0,
			},
			FastestTime = {
				["Raid"] = 0,
			},
			Stars = {
				["Raid"] = 0,
			},
		},
	},
}

local MerchantItemsBoughtTemplate = {
	Day = 0,
	ItemsBought = {},
	--ItemsBought = {[ItemName] = Amount}
}

local QuestTableTemplate = {
	Day = 0,
	Week = 0,
	ActiveQuests = {},
	FinishedQuests = {},
	--ActiveQuests = {[QuestNameInRegistry] = 0},
	--FinishedQuests = {[QuestNameInRegistry] = true},
}

local ProfileTemplate = {
	Currencies = {
		Gold = 0,
		Gems = 500,
		["Red Ticket"] = 0,
		["Candy Cane"] = 0,
		["New Year Coin"] = 0,
	},
	BattlepassData = {
		Level = 0,
		Exp = 0,
		BattlepassName = "",
		ClaimedFree = 0,
		ClaimedPremium = 0,
		HasPremium = false,
		ResetExp = false,
	},
	AdventCalendarData = {
		Name = "",
		Claimed = {},
		OnlineDays = 0,
	},
	PoolData = {
		["NewYearCrate"] = {
			AutoSell = {},
			Pity = {
				ExclusivePity = 0,
				SecretPity = 0,
				MythicalPity = 0,
			},
		},
		["ValentineCrate"] = {
			AutoSell = {},
			Pity = {
				SecretPity = 0,
				MythicalPity = 0,
				LegendaryPity = 0,
			},
		},
		["SpecialCrate"] = {
			AutoSell = {},
		},
	},

	EventShopData = {
		Bought = {},
	},

	CollisionEventData = {
		Bought = {},
	},

	RaidShopData = {
		Bought = {},
	},

	DungeonShopData = {
		Bought = {},
	},

	TeamEventData = {
		Shop = {
			Bought = {},
		},

		ContributedSouls = 0,
		ContributedReaperParts = 0,

		Battlepass = {
			Level = 0,
			Exp = 0,
			BattlepassName = "",
			Claimed = {
				["Regular"] = {},
				["Premium"] = {},
			},
			HasPremium = false,
			ResetExp = false,
		},

		GlobalBattlepass = {
			Level = 0,
			Exp = 0,
			BattlepassName = "",
			Claimed = {
				["Regular"] = {},
				["Premium"] = {},
			},
			HasPremium = false,
			ResetExp = false,
		},
		Team = nil,

		HasClaimed = nil,
	},

	CurrencyExchangerData = {
		Day = 0,
		Exchanged = 0,
	},

	SummoningData = {
		MythicalPity = 0,
		FeaturedMythicalPity = 0,
		LegendaryPity = 0,
		SecretPity = 0,
		LastBannerSeed = 0,
	},

	SummoningEventData = {
		FeaturedMythicalPity = 0,
		MythicalPity = 0,
		LegendaryPity = 0,
		SecretPity = 0,
		LastBannerSeed = 0,
	},

	DragonCapsuleData = {
		MythicalPity = 0,
		LegendaryPity = 0,
		GohanEventPity = 0,
	},
	Level = 1,
	XP = 0,
	RobuxSpent = 0,
	Quests = QuestTableTemplate,
	Slotbar = SlotbarTemplate,
	CurrentTitle = "",
	EquippedMount = "",
	Inventory = {
		Units = {},
		Items = {},
		Titles = {},
		Mounts = {},
		Skins = {},
		MaxUnitStorage = 100,
	},
	Settings = {
		SoundMasterVolume = 1,
		UnitSFXVolume = 1,
		BGMVolume = 1,
		GeneralSFXVolume = 1,
		UnitVFX = true,
		StatusEffectVFX = true,
		AutoSkip = false,
		DamageIndicator = true,
		ShowMaxRangeOnPlace = true,
		AutoSell = {},
		DragonCapsuleAutoSell = {},
		SummonAnimation = true,
		TraitRerollCooldown = 0.5,
		LowGFX = false,
		ReducedColorIntensity = false,
		ReducedBloomntensity = false,
		PerformantWindows = false,
		AutoLockMythicals = true,
		AutoLockSecrets = true,
		InstantCrateOpen = false,
	},

	IndexData = {
		UnlockedUnits = {},
		ClaimedLevelRewards = {},
		IndexLevel = 0,
		IndexXP = 0,
	},

	AFKData = {
		GemTimeSpent = 0,
		RerollTimeSpent = 0,
		UnitTimeSpent = 0,

		SessionData = {
			GemsGained = 0,
			TraitRerollsGained = 0,
			ObtainedUnits = {},
			Uptime = 0,
		},
	},

	DailyRewardsData = {
		LastDay = 0,
		CurrentDay = 1,
		ClaimedDays = 0,
	},

	NPCData = {
		ClaimedBuilderGems = false,
		ClaimedFreeTraitRerolls = false,
		ClaimedGroupPrize = false,
		ClaimedTutorial = false,
	},

	LeaderboardData = {
		PendingRewards = {},
		CheckedSeasons = {},
		LastSeasonUpdate = 0,
	},

	--MissionCompletionData = '{"Story":{"West City":[]}}',
	MissionCompletionData = {
		Story = CompletedMissionStoryTemplate,
		Infinite = CompletedMissionInfiniteTemplate,
		Legend = {},
		Challenge = {},
		Adventure = {},
		Raid = CompletedMissionRaidTemplate,
		Dungeon = CompletedMissionDungeonTemplate,
	},

	ChallengeLockData = {
		Seeds = {},
		Time = 0,
	},

	ProductsBought = {},
	FailedPurchases = {},
	RedeemedCodes = {},
	ClaimedLevelRewards = {},
	MerchantItemsBought = MerchantItemsBoughtTemplate,
	PlayerStatistics = {
		Kills = 0,
		TotalDamage = 0,
		GamesPlayed = 0,
		PlayTime = 0,
		TotalSummons = 0,
		SummonedShinies = 0,
		SummonedMythicals = 0,
		SummonedSecrets = 0,
	},
	Teams = {},
	SlotsApplicable = 3,
	TraitPity = {
		["Mythical"] = 0,
		["Secret"] = 0,
	},
	Effects = {},
	Blessing = {
		["Name"] = "",
		["UUID"] = "",
	},
	NPCZonesData = {
		AlchemyZone = true,
		CraftingZone = true,
		GoodBuilder = true,
		SoloWooZone = true,
		GroupZone = true,
		SecretPresent = true,
		LevelRewards = true,
		MerchantZone = true,
		SummonZone = true,
		TraitRerollZone = true,
		UnitIndexZone = false,
	},

	PatchData = {
		BundleUseReset = false,
		RaidShopResetUnix = 1735408800,
		DungeonShopResetUnix = 1735408800,
	}, --any patch related stuff goes here

	Bundles = {},

	BingoData = {
		NextBingoIn = 0,
		Quests = {},
		Claimed = {},
		TotalClaimedRows = 0,
	},

	HellTowerData = {
		HighestRoom = 0,
		Season = 1,

		RoomCompletionData = {
			["1"] = {
				["ClearAmount"] = 0,
				["FastestTime"] = 0,
			},
		},

		ClaimData = {
			--[FLOOR NUMBER] = true
		},
	},

	TournamentsData = {
		PreviousResults = {},

		Bracket = nil,

		Damage = 0,
		Kills = 0,

		CurrentTournament = nil,
	},

	Easter2025Score = 0,

	WinsWithSpeed = 0,
}

return ProfileTemplate
