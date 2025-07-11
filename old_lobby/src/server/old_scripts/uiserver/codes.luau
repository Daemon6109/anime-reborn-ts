local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
--local DataStoreService = game:GetService("DataStoreService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)

local DataAPI = DataAccess:GetAPI()

local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer_2
local UiCommunication = ReplicatedStorage.Events.UiCommunication

local REDEEM_ATTEMPT_COOLDOWN = 6

export type CodeDataType = {
	ExpireDate: number?,
	Rewards: RewardLibrary.RewardType,
	UseLimit: number?, -- Global use limit for the code
	AmountUsed: number?, -- Only gets tracked if UseLimit exists. Make sure to make it zero when adding a new code
	RoleExclusive: table?,
	LevelRequirement: number?,
	BoughtProductId: any?,
}

type Code = {
	ExpireData: number,
	Rewards: RewardLibrary.RewardType,
	Code: string,
}

local function createCode(props: CodeDataType): CodeDataType
	return props
end

local codes = {
	--createCode({
	--	Code = string.lower("Test"),
	--	ExpireDate = DateTime.fromUniversalTime(2025,5,30).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 15,
	--		},
	--	}}
	--),
	createCode({
		Code = string.lower("BannerCostFixed"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 15,
			},
		},
	}),

	createCode({
		Code = string.lower("PATCH"),
		ExpireDate = DateTime.fromUniversalTime(2025, 6, 1).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 100,
				FrostKey = 30,
				PotentialKey = 30,
				RainbowStar = 3,
			},
			Currencies = {
				Gems = 5000,
			},
		},
	}),

	createCode({
		Code = string.lower("domainexpansion!"),
		ExpireDate = DateTime.fromUniversalTime(2025, 6, 1).UnixTimestamp,
		Rewards = {
			Items = {
				["TraitCrystal"] = 20,
				["Vyasche Item"] = 1,
				["Dragon Ball (7)"] = 1,
			},
		},
	}),

	createCode({
		Code = string.lower("Crystals"),
		ExpireDate = DateTime.fromUniversalTime(2025, 6, 1).UnixTimestamp,
		Rewards = {
			Items = {
				["Fierce Crystal"] = 10,
				["Fire Crystal"] = 10,
				["Dark Crystal"] = 10,
				["Light Crystal"] = 10,
				["Wind Crystal"] = 10,
				["Water Crystal"] = 10,
			},
		},
	}),

	--LevelRequirement = 10

	createCode({
		Code = string.lower("SorryForDelay"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
			},
			Currencies = {
				Gems = 10000,
			},
		},
	}),
	--LevelRequirement = 10
	createCode({
		Code = string.lower("NewBanner"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 15,
			},
			Currencies = {
				Gems = 3000,
			},
		},
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("Reborn"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
				BasicLuckPotion = 1,
			},
		},
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("TournamentofPower"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 30).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 20,
			},
			Currencies = {
				Gems = 5000,
			},
		},
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("Podcastgang!!"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 22).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 30,
				FrostKey = 20,
				PotentialKey = 15,
				RainbowStar = 3,
			},
		},
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("Hunters"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 16).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
				FrostKey = 4,
			},
		},
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("Quimera"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 16).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 5,
				FrostKey = 5,
			},
			Currencies = {
				Gems = 1000,
			},
		},
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("Requiem"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 16).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
			},
			Currencies = {
				Gems = 1000,
			},
		},
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("GoodnightTestersIGoZzz"),
		ExpireDate = DateTime.fromUniversalTime(2026, 4, 7).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 150,

				PotentialKey = 100,
				FrostKey = 50,

				RainbowStar = 30,

				GreenStar = 30,
				PurpleStar = 30,
				RedStar = 30,
				BlueStar = 30,

				OrangeStar = 30,
			},
			Currencies = {
				Gems = 12000,
			},
		},
		RoleExclusive = { "Tester", "[CLOSED] Tester", "Moderator", "Admin" },
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("ARFTW"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 14).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 5,
			},
			Currencies = {
				Gems = 500,
			},
		},
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("PodcastGoats"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 14).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 15,
				FrostKey = 5,
			},
		},
		--LevelRequirement = 10
	}),

	createCode({
		Code = string.lower("HAPPYEASTER25!!"),
		ExpireDate = DateTime.fromUniversalTime(2025, 4, 14).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
			},
			Currencies = {
				Gems = 1000,
			},
		},
		--LevelRequirement = 10
	}),
} :: Code

--local CodeDataStore = DataStoreService:GetDataStore("CodesV6")
--local RunService = game:GetService('RunService')

--if RunService:IsStudio() then

--CodeDataStore:SetAsync(string.lower('BannerCostFixed'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,30).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 15,
--		},
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('SorryForDelay'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,30).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 10,
--		},
--		Currencies = {
--			Gems = 10000,
--		}
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('NewBanner'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,30).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 15,
--		},
--		Currencies = {
--			Gems = 3000,
--		}
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('Reborn'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,30).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 10,
--			BasicLuckPotion = 1,
--		},
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('TournamentofPower'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,30).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 20,
--		},
--		Currencies = {
--			Gems = 5000,
--		}
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('Podcastgang!!'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,22).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 30,
--			FrostKey = 20,
--			PotentialKey = 15,
--			RainbowStar = 3
--		},
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('Hunters'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,16).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 10,
--			FrostKey = 4,
--		},
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('Quimera'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,16).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 5,
--			FrostKey = 5,
--		},
--		Currencies = {
--			Gems = 1000,
--		}
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('Requiem'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,16).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 10,
--		},
--		Currencies = {
--			Gems = 1000,
--		}
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('GoodnightTestersIGoZzz'),{
--	ExpireDate = DateTime.fromUniversalTime(2026,4,7).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 150,

--			PotentialKey = 100,
--			FrostKey = 50,

--			RainbowStar = 30,

--			GreenStar = 30,
--			PurpleStar = 30,
--			RedStar = 30,
--			BlueStar = 30,

--			OrangeStar = 30
--		},
--		Currencies = {
--			Gems = 12000,
--		}
--	},
--		RoleExclusive = {"Tester", "[CLOSED] Tester", "Moderator", "Admin"}
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('ARFTW'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,14).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 5,
--		},
--		Currencies = {
--			Gems = 500,
--		}
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('PodcastGoats'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,14).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 15,
--			FrostKey = 5
--		}
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--CodeDataStore:SetAsync(string.lower('HAPPYEASTER25!!'),{
--	ExpireDate = DateTime.fromUniversalTime(2025,4,14).UnixTimestamp,
--	Rewards = {
--		Items = {
--			TraitCrystal = 10,
--		},
--		Currencies = {
--			Gems = 1000,
--		}
--	},
--	--LevelRequirement = 10

--}::CodeDataType)

--[[CodeDataStore:SetAsync(string.lower('Dressrosa!'),{
		ExpireDate = DateTime.fromUniversalTime(2025,4,7).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
				FrostKey = 5
			}
		},
		--LevelRequirement = 10

	}::CodeDataType)

	CodeDataStore:SetAsync(string.lower('OnePeak!'),{
		ExpireDate = DateTime.fromUniversalTime(2025,4,7).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 5,
			},
			Currencies = {
				Gems = 6000,
			}
		},
		--LevelRequirement = 10

	}::CodeDataType)

	CodeDataStore:SetAsync(string.lower('Gear4TH!'),{
		ExpireDate = DateTime.fromUniversalTime(2025,4,7).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 15,
				FrostKey = 10
			},
			Currencies = {
				Gems = 6000,
			}
		},
		--LevelRequirement = 10

	}::CodeDataType)

	CodeDataStore:SetAsync(string.lower('PODI1!'),{
		ExpireDate = DateTime.fromUniversalTime(2025,4,7).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
			}
		},
		--LevelRequirement = 10

	}::CodeDataType)
	

	CodeDataStore:SetAsync(string.lower('PODI2!'),{
		ExpireDate = DateTime.fromUniversalTime(2025,4,7).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 10,
			}
		},
		--LevelRequirement = 10

	}::CodeDataType)

	CodeDataStore:SetAsync(string.lower('TheSkipsareREAL!'),{
		ExpireDate = DateTime.fromUniversalTime(2030,3,25).UnixTimestamp,
		Rewards = {
			Items = {
				["Story Skip (West City)"] = 1,
				["Story Skip (Leaf Village)"] = 1,
				["Story Skip (Land of the Sky)"] = 1
			}
		},
		--LevelRequirement = 10

	}::CodeDataType)

	CodeDataStore:SetAsync(string.lower('Delta!!'),{
		ExpireDate = DateTime.fromUniversalTime(2025,3,25).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 5,
			},
			Currencies = {
				Gems = 500,
			}
		},
		--LevelRequirement = 10

	}::CodeDataType)
	
	CodeDataStore:SetAsync(string.lower('QOL'),{
		ExpireDate = DateTime.fromUniversalTime(2025,3,25).UnixTimestamp,
		Rewards = {
			Items = {
				TraitCrystal = 5,
			},
			Currencies = {
				Gems = 1000,
			}
		},
		--LevelRequirement = 10

	}::CodeDataType)
	
	--CodeDataStore:SetAsync(string.lower('PodcastOnez!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 20,

	--		},
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)
	
	--CodeDataStore:SetAsync(string.lower('FeedBack!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 15,

	--		},
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)
	
	--CodeDataStore:SetAsync(string.lower('GuttedUlquiorraHAHA!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,22).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 15,

	--		},
	--		Currencies = {
	--			Gems = 6000,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('PodcastGang!!!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 10,

	--		},
	--		Currencies = {
	--			Gems = 5000,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)


	--CodeDataStore:SetAsync(string.lower('THEPPODCASTGANGDONTSTOP'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 30,
	--			FrostKey = 10,
	--		},
	--		Currencies = {
	--			Gems = 5000,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('THEANTKING!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 10,
 --                Crystals = 50
	--		},
	--		Currencies = {
	--			Gems = 3500,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('The50RRCODEFIXED!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,4,5).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 50,

	--		},

	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('Limited Skins'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Currencies = {
	--			Gems = 1250,
	--		}
	--	},
	--	--LevelRequirement = 10
	--}::CodeDataType)


	--CodeDataStore:SetAsync(string.lower('UpdateSunday!!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 25,
	--		},
	
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('SoloLeveling!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			ManaCrystals = 50,
	--			TraitCrystal = 25,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('Resseruction!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			FrostKey = 3,
	--			TraitCrystal = 5,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('VastoLorde'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
		
	--			TraitCrystal = 5,
	--		},
	--		Currencies = {
	--			Gems = 500,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)



	--CodeDataStore:SetAsync(string.lower('ichikoooo!!!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {

	--			TraitCrystal = 5,
	--			FrostKey = 1,
	--		},
	--		Currencies = {
	--			Gems = 500,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('WEBACK!!'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			FrostKey = 5,
	--			TraitCrystal = 10,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)


	--CodeDataStore:SetAsync(string.lower('Infcastle'),{
	--	ExpireDate = DateTime.fromUniversalTime(2025,3,20).UnixTimestamp,
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 10,
	--		}
	--	},
	--	--LevelRequirement = 10

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('!RetiredAssassin'),{
	--	ExpireDate = 1738346400 + (14*86400),
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 5,
	--			BasicLuckPotion = 1,
	--		},
	--		Currencies = {
	--			Gems = 2500,
	--		},
	--	},
	--	LevelRequirement = 15

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('!NebulaPass'),{
	--	ExpireDate = 1738346400 + (14*86400),
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 5,
	--			PotentialKey = 10,
	--			FrostKey = 15,
	--		},
	--	},
	--	LevelRequirement = 15

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('!sneakpeak'),{
	--	ExpireDate = 1738346400 + (14*86400),
	--	Rewards = {
	--		Items = {
	--			TraitCrystal = 10,
	--			BasicLuckPotion = 1,
	--		},
	--		Currencies = {
	--			Gems = 1000,
	--		},
	--	},
	--	LevelRequirement = 10

	--}::CodeDataType)

	-------------------------------------------

	--CodeDataStore:SetAsync(string.lower('WeAreSorryForDelay'),{
	--	ExpireDate = 2736012540,
	--	Rewards = {
	--		Currencies = {
	--			['Candy Cane'] = 25_000,
	--		},
	--		Items = {
	--			TraitCrystal = 25,
	--			PotentialKey = 10,
	--		}
	--	},

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('!Worldcollision'),{
	--	ExpireDate = 2736012540,
	--	Rewards = {
	--		Currencies = {
	--			['New Year Coin'] = 10_000,
	--		},
	--		Items = {

	--		}
	--	},

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('20kreacts'),{
	--	ExpireDate = 1736955043+(7*86400),
	--	Rewards = {
	--		Currencies = {
	--			['New Year Coin'] = 10_000,
	--		},
	--		Items = {
	--			TraitCrystal = 10,
	--		}
	--	},

	--}::CodeDataType)

	--CodeDataStore:SetAsync(string.lower('delayborn2'),{
	--	ExpireDate = 1736012540,
	--	Rewards = {
	--		Currencies = {
	--			Gems = 5000,
	--			['Candy Cane'] = 10_000,

	--		},
	--		Items = {
	--			TraitCrystal = 30,
	--			EnchantedCandyKey = 3,
	--		},

	--	}
	--}::CodeDataType)]]

local Codes = {
	RedeemCode = function(player: Player, Code: string)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local CanResetCooldown = true

		if player:GetAttribute("CodeRedeemCooldown") then
			return
		end

		player:SetAttribute("CodeRedeemCooldown", true)

		task.delay(REDEEM_ATTEMPT_COOLDOWN, function()
			if CanResetCooldown then
				player:SetAttribute("CodeRedeemCooldown", nil)
			end
		end)

		Code = tostring(Code)
		Code = Code:lower()

		if table.find(PlayerProfile:GetField("RedeemedCodes"), Code) then
			return
		end

		local function findCode()
			for _, v in pairs(codes) do
				if v.Code == Code then
					return v
				end
			end
		end

		local FoundCode = findCode()

		if not FoundCode then
			NotifyPlayer:FireClient(player, "Error", "Invalid Code!")

			return
		end

		if FoundCode.RoleExclusive and not table.find(FoundCode.RoleExclusive, player:GetRoleInGroup(33820338)) then
			NotifyPlayer:FireClient(player, "Error", "Invalid Code! You cant redeem this")
			return
		end

		local Level = PlayerProfile:GetField("Level") or 0

		if FoundCode.LevelRequirement and Level < FoundCode.LevelRequirement then
			NotifyPlayer:FireClient(
				player,
				"Error",
				`You must be level {FoundCode.LevelRequirement} to redeem this code!`
			)
			return
		end

		local ProductsBought = PlayerProfile:GetField("ProductsBought")

		if FoundCode.BoughtProductId then
			local BoughtProduct = false

			if typeof(FoundCode.BoughtProductId) == "number" then
				FoundCode.BoughtProductId = { FoundCode.BoughtProductId }
			end

			for i, v in FoundCode.BoughtProductId do
				if ProductsBought[tostring(v)] then
					BoughtProduct = true
				end
			end

			warn("product bought", BoughtProduct)

			if not BoughtProduct then
				NotifyPlayer:FireClient(player, "Error", `You must own the product to redeem this code!`)
				return
			end
		end

		if FoundCode.ExpireDate and FoundCode.ExpireDate < DateTime.now().UnixTimestamp then
			NotifyPlayer:FireClient(player, "Error", "This code has expired!")

			return
		end

		local RedeemedCodes = PlayerProfile:GetField("RedeemedCodes")

		table.insert(RedeemedCodes, Code)

		PlayerProfile:WriteField("RedeemedCodes", RedeemedCodes, true)
		RewardLibrary:RewardPlayer(player, FoundCode.Rewards)

		NotifyPlayer:FireClient(player, "Success", "Code Redeemed!")

		player:SetAttribute("CodeRedeemCooldown", nil)
	end,
}

return Codes
