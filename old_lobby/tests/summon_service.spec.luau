--[[
	SummonService Tests
	
	Tests for the SummonService module covering banner management, 
	summoning mechanics, pity systems, and shiny calculations.
]]

local JestGlobals = require("@devpkgs/jest-globals")
local expect = JestGlobals.expect
local jest = JestGlobals.jest
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local SummonService = require("@server/summon_service")

-- Mock dependencies
local mockPlayer = {
	DisplayName = "TestPlayer",
	Name = "testplayer",
	UserId = 12345,
}

local mockPerson = {
	getPlayer = function()
		return mockPlayer
	end,
}

local mockPlayerProfileClass = {
	GetField = jest.fn(),
	WriteField = jest.fn(),
	WriteDirectory = jest.fn(),
	ReplicateField = jest.fn(),
}

local mockDataAPI = {
	GetActivePlayerProfileClass = jest.fn().mockReturnValue(mockPlayerProfileClass),
	SaveProfile = jest.fn(),
}

local mockUnitRegistry = {
	["TestUnit"] = {
		configuration = {
			Rarity = "Legendary",
			DisplayName = "Test Unit",
		},
		raw = {
			FindFirstChild = jest.fn().mockReturnValue(nil),
		},
	},
	["ShinyUnit"] = {
		configuration = {
			Rarity = "Mythical",
			DisplayName = "Shiny Unit",
		},
		raw = {
			FindFirstChild = jest.fn().mockReturnValue({ Value = true }),
		},
	},
	["SecretUnit"] = {
		configuration = {
			Rarity = "Secret",
			DisplayName = "Secret Unit",
		},
		raw = {
			FindFirstChild = jest.fn().mockReturnValue({ Value = true }),
		},
	},
}

local mockBannerPool = {
	ReturnPool = jest.fn(),
}

local mockGameFunctions = {
	SummonChances = {
		Rare = 0.6,
		Epic = 0.25,
		Legendary = 0.1,
		Mythical = 0.04,
		Secret = 0.01,
	},
	CalculateSellCost = jest.fn().mockReturnValue(100),
	HasVIP = jest.fn().mockReturnValue(false),
}

local mockSyncedTime = {
	time = jest.fn().mockReturnValue(3600), -- 1 hour
}

-- Setup global mocks
_G.Registry = { registry = { Units = mockUnitRegistry } }
_G.serverServices = {
	UnitManager = {
		giveUnit = jest.fn().mockReturnValue({ "unit-uuid-123" }),
	},
	PlayerService = {
		GiveCurrency = jest.fn(),
	},
	QuestHandler = {
		GivePointsByPointType = jest.fn(),
	},
	BingoService = {
		AddProgress = jest.fn(),
	},
	TitleService = {
		GiveTitle = jest.fn(),
	},
	MessagingHandler = {
		PublishAsync = jest.fn(),
	},
	EffectService = {
		CalculateMultiplier = jest.fn().mockReturnValue(1),
	},
}

-- Mock require calls
jest.doMock("@pkgs/shingo", function()
	return {
		new = function()
			return {
				fire = jest.fn(),
				connect = jest.fn(),
			}
		end,
	}
end)

jest.doMock("@commonserver/person", function()
	return {}
end)

jest.doMock("@network/server", function()
	return {
		new = function()
			return {
				event = jest.fn(),
				func = jest.fn(),
			}
		end,
	}
end)

-- Mock game services
game = {
	GetService = function(serviceName)
		if serviceName == "AnalyticsService" then
			return { LogCustomEvent = jest.fn() }
		elseif serviceName == "HttpService" then
			return { JSONEncode = jest.fn().mockReturnValue("{}") }
		elseif serviceName == "Players" then
			return {}
		elseif serviceName == "ReplicatedStorage" then
			return {
				GameVariables = {
					SummonTime = { Value = "3600" },
				},
			}
		elseif serviceName == "ServerScriptService" then
			return {
				ServerLibs = {
					DataAccessAPI = {
						GetAPI = function()
							return mockDataAPI
						end,
					},
				},
			}
		elseif serviceName == "DataStoreService" then
			return {
				GetDataStore = function()
					return {
						GetAsync = jest.fn().mockReturnValue(nil),
					}
				end,
			}
		end
		return {}
	end,
}

workspace = {
	SetAttribute = jest.fn(),
	GetAttribute = jest.fn(),
}

require = function(path)
	if string.find(path, "Registry.BannerPool") then
		return mockBannerPool
	elseif string.find(path, "Libs.GameFunctions") then
		return mockGameFunctions
	elseif string.find(path, "Libs.SyncedTime") then
		return mockSyncedTime
	end
	return {}
end

describe("SummonService", function()
	local summonService

	beforeEach(function()
		summonService = SummonService.new()

		-- Setup mock banner data
		mockBannerPool.ReturnPool.mockImplementation(function(poolType)
			if poolType == "Standard" then
				return {
					Secret = { "SecretUnit" },
					Mythical = { "ShinyUnit" },
					Legendary = { "TestUnit" },
					Epic = { "TestUnit" },
					Rare = { "TestUnit" },
				}
			else -- Mythical
				return {
					Secret = { "SecretUnit" },
					Mythical = { "ShinyUnit" },
					Legendary = { "TestUnit" },
					Epic = { "TestUnit" },
					Rare = { "TestUnit" },
				}
			end
		end)

		-- Setup default player data
		mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
			if field == "Level" then
				return 20
			elseif field == "Currencies" then
				return { Gems = 1000, Gold = 5000 }
			elseif field == "SummoningData" then
				return {
					LegendaryPity = 0,
					MythicalPity = 0,
					SecretPity = 0,
					FeaturedMythicalPity = 0,
					LastBannerSeed = 0,
				}
			elseif field == "Settings" then
				return {
					AutoSell = {},
					DragonCapsuleAutoSell = {},
				}
			elseif field == "Inventory" then
				return {
					Units = {},
					MaxUnitStorage = 100,
					Titles = {},
				}
			elseif field == "PlayerStatistics" then
				return {
					TotalSummons = 0,
					SummonedSecrets = 0,
					SummonedMythicals = 0,
					SummonedShinies = 0,
				}
			elseif field == "ProductsBought" then
				return {}
			end
			return {}
		end)
	end)

	describe("initialization", function()
		it("should create a new SummonService instance", function()
			expect(summonService).toBeDefined()
			expect(summonService.version).toEqual({ major = 1, minor = 0, patch = 0 })
		end)

		it("should initialize banner state", function()
			expect(summonService.currentBanner).toBeDefined()
			expect(summonService.mythicalBanner).toBeDefined()
		end)

		it("should create events", function()
			expect(summonService.unitSummoned).toBeDefined()
			expect(summonService.bannerUpdated).toBeDefined()
			expect(summonService.pityActivated).toBeDefined()
			expect(summonService.shinyObtained).toBeDefined()
		end)
	end)

	describe("getCurrentBanner", function()
		it("should return standard banner by default", function()
			summonService.currentBanner = {
				Mythical = "TestUnit",
				Legendary = "TestUnit",
				Epic = { "TestUnit" },
				Rare = { "TestUnit" },
			}

			local banner = summonService:getCurrentBanner()
			expect(banner.Secret).toBeNil()
			expect(banner.Mythical).toBe("TestUnit")
		end)

		it("should return mythical banner when requested", function()
			local banner = summonService:getCurrentBanner("get_Mythical")
			expect(banner.Secret).toBeNil()
			expect(banner.Mythical_2).toBeDefined()
		end)
	end)

	describe("toggleAutoSell", function()
		it("should toggle auto-sell for valid rarities", function()
			local result = summonService:toggleAutoSell(mockPerson, "Epic")
			expect(result).toBe(true)
			expect(mockPlayerProfileClass.WriteDirectory).toHaveBeenCalledWith(
				mockPlayerProfileClass,
				"Settings/AutoSell",
				{ "Epic" },
				true
			)
		end)

		it("should return nil for invalid rarities", function()
			local result = summonService:toggleAutoSell(mockPerson, "Secret")
			expect(result).toBeNil()
		end)

		it("should remove rarity if already in auto-sell list", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "Settings" then
					return { AutoSell = { "Epic" } }
				end
				return {}
			end)

			local result = summonService:toggleAutoSell(mockPerson, "Epic")
			expect(result).toBe(false)
		end)
	end)

	describe("calculateShinyChance", function()
		it("should calculate base shiny chance", function()
			local chance = summonService:calculateShinyChance(mockPerson)
			expect(chance).toBe(0.01) -- Base 1% chance
		end)

		it("should apply effect multipliers", function()
			_G.serverServices.EffectService.CalculateMultiplier.mockReturnValue(2)

			local chance = summonService:calculateShinyChance(mockPerson)
			expect(chance).toBe(0.02) -- 2x multiplier
		end)

		it("should apply VIP gamepass bonus", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "ProductsBought" then
					return { ["1932432116"] = true }
				end
				return {}
			end)

			local chance = summonService:calculateShinyChance(mockPerson)
			expect(chance).toBe(0.02) -- Base + VIP bonus
		end)
	end)

	describe("updatePity", function()
		it("should increase pity counter", function()
			local activated = summonService:updatePity(mockPerson, "LegendaryPity", 5)
			expect(activated).toBe(false)
			expect(mockPlayerProfileClass.WriteField).toHaveBeenCalledWith(
				mockPlayerProfileClass,
				"SummoningData",
				expect.objectContaining({ LegendaryPity = 5 }),
				false
			)
		end)

		it("should activate pity when limit reached", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "SummoningData" then
					return {
						LegendaryPity = 45, -- Close to limit of 50
						MythicalPity = 0,
						SecretPity = 0,
						FeaturedMythicalPity = 0,
						LastBannerSeed = 0,
					}
				end
				return {}
			end)

			local activated = summonService:updatePity(mockPerson, "LegendaryPity", 10)
			expect(activated).toBe(true)
			expect(summonService.pityActivated.fire).toHaveBeenCalledWith(
				summonService.pityActivated,
				mockPerson,
				"LegendaryPity",
				50
			)
		end)
	end)

	describe("summon", function()
		beforeEach(function()
			-- Initialize banner data
			summonService.currentBanner = {
				Secret = "SecretUnit",
				Mythical = "ShinyUnit",
				Legendary = "TestUnit",
				Epic = { "TestUnit" },
				Rare = { "TestUnit" },
			}

			summonService.mythicalBanner = {
				Secret = "SecretUnit",
				Mythical = { "ShinyUnit" },
				Epic = { "TestUnit" },
				Rare = { "TestUnit" },
			}
		end)

		it("should fail if service not initialized", function()
			summonService._unitManager = nil

			local result = summonService:summon(mockPerson, "Summon1")
			expect(result.success).toBe(false)
			expect(result.error).toBe("Service not initialized")
		end)

		it("should fail with insufficient gems", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "Currencies" then
					return { Gems = 10 } -- Not enough for 50 gem cost
				elseif field == "Inventory" then
					return { Units = {}, MaxUnitStorage = 100 }
				elseif field == "Settings" then
					return { AutoSell = {} }
				elseif field == "PlayerStatistics" then
					return {
						TotalSummons = 0,
						SummonedSecrets = 0,
						SummonedMythicals = 0,
						SummonedShinies = 0,
					}
				end
				return {}
			end)

			local result = summonService:summon(mockPerson, "Summon1")
			expect(result.success).toBe(false)
			expect(result.error).toBe("Insufficient gems")
		end)

		it("should fail with insufficient inventory space", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "Currencies" then
					return { Gems = 1000 }
				elseif field == "Inventory" then
					return {
						Units = {}, -- 100 units (at max)
						MaxUnitStorage = 1, -- Only 1 space
					}
				elseif field == "Settings" then
					return { AutoSell = {} }
				end
				return {}
			end)

			local result = summonService:summon(mockPerson, "Summon10")
			expect(result.success).toBe(false)
			expect(result.error).toBe("Insufficient inventory space")
		end)

		it("should successfully perform single summon", function()
			local result = summonService:summon(mockPerson, "Summon1")
			expect(result.success).toBe(true)
			expect(result.results).toBeDefined()
			expect(#result.results).toBe(1)

			-- Should deduct gems
			expect(_G.serverServices.PlayerService.GiveCurrency).toHaveBeenCalledWith(
				_G.serverServices.PlayerService,
				mockPlayer,
				"Gems",
				-50
			)

			-- Should update quest progress
			expect(_G.serverServices.QuestHandler.GivePointsByPointType).toHaveBeenCalledWith(
				_G.serverServices.QuestHandler,
				mockPlayer,
				"Summons",
				1
			)
		end)

		it("should successfully perform multi summon", function()
			local result = summonService:summon(mockPerson, "Summon10")
			expect(result.success).toBe(true)
			expect(result.results).toBeDefined()
			expect(#result.results).toBe(10)

			-- Should deduct more gems for multi
			expect(_G.serverServices.PlayerService.GiveCurrency).toHaveBeenCalledWith(
				_G.serverServices.PlayerService,
				mockPlayer,
				"Gems",
				-500
			)
		end)

		it("should handle auto-sell correctly", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "Settings" then
					return { AutoSell = { "Legendary" } } -- Auto-sell legendary units
				elseif field == "Currencies" then
					return { Gems = 1000 }
				elseif field == "Inventory" then
					return { Units = {}, MaxUnitStorage = 100 }
				elseif field == "PlayerStatistics" then
					return {
						TotalSummons = 0,
						SummonedSecrets = 0,
						SummonedMythicals = 0,
						SummonedShinies = 0,
					}
				end
				return {}
			end)

			local result = summonService:summon(mockPerson, "Summon1")
			expect(result.success).toBe(true)

			-- Should give gold for auto-sold units
			local totalGold = 0
			for _, summonResult in result.results do
				if summonResult.wasSold then
					totalGold += summonResult.goldEarned or 0
				end
			end

			if totalGold > 0 then
				expect(_G.serverServices.PlayerService.GiveCurrency).toHaveBeenCalledWith(
					_G.serverServices.PlayerService,
					mockPlayer,
					"Gold",
					totalGold,
					true
				)
			end
		end)

		it("should fire unitSummoned event", function()
			local result = summonService:summon(mockPerson, "Summon1")
			expect(result.success).toBe(true)
			expect(summonService.unitSummoned.fire).toHaveBeenCalledWith(
				summonService.unitSummoned,
				mockPerson,
				"Summon1",
				result.results
			)
		end)
	end)

	describe("getBannerPercentages", function()
		it("should return base chance for non-boosted rarities", function()
			local chance = summonService:getBannerPercentages(mockPerson, "Rare")
			expect(chance).toBe(0.6) -- From mock SummonChances
		end)

		it("should apply luck multiplier to boosted rarities", function()
			_G.serverServices.EffectService.CalculateMultiplier.mockReturnValue(1.5)

			local chance = summonService:getBannerPercentages(mockPerson, "Mythical")
			expect(chance).toBe(0.06) -- 0.04 * 1.5
		end)
	end)
end)
