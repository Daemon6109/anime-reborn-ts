--[[
	TournamentService Tests
	
	Tests for the TournamentService module covering tournament management,
	leaderboards, rewards, and player participation.
]]

local JestGlobals = require("@devpkgs/jest-globals")
local expect = JestGlobals.expect
local jest = JestGlobals.jest
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local TournamentService = require("../src/server/tournament_service")

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
}

local mockDataAPI = {
	GetActivePlayerProfileClass = jest.fn().mockReturnValue(mockPlayerProfileClass),
}

local mockTournamentDataModule = {
	ReturnTournament = jest.fn(),
}

local mockRewardLibrary = {
	ProcessReward = jest.fn().mockReturnValue({ gems = 100 }),
}

local mockDataStore = {
	GetSortedAsync = jest.fn(),
	SetAsync = jest.fn(),
}

-- Setup global mocks
_G.serverServices = {
	PlayerService = {
		GiveCurrency = jest.fn(),
	},
	NotificationService = {
		notify = jest.fn(),
	},
	TeleportService = {
		teleport = jest.fn(),
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
		elseif serviceName == "DataStoreService" then
			return {
				GetOrderedDataStore = jest.fn().mockReturnValue(mockDataStore),
			}
		elseif serviceName == "HttpService" then
			return { JSONEncode = jest.fn().mockReturnValue("{}") }
		elseif serviceName == "Players" then
			return {
				PlayerAdded = { Connect = jest.fn() },
				GetPlayers = jest.fn().mockReturnValue({}),
			}
		elseif serviceName == "ReplicatedStorage" then
			return {
				Events = {
					TeleportingToggle = { FireClient = jest.fn() },
					NotifyPlayer = { FireClient = jest.fn() },
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
		elseif serviceName == "TeleportService" then
			return {
				TeleportAsync = jest.fn().mockReturnValue(true),
			}
		end
		return {}
	end,
	GameId = 6717025335,
}

-- Mock modules
require = function(path)
	if string.find(path, "Registry.TournamentData") then
		return mockTournamentDataModule
	elseif string.find(path, "Libs.RewardLibrary") then
		return mockRewardLibrary
	end
	return {}
end

describe("TournamentService", function()
	local tournamentService

	beforeEach(function()
		tournamentService = TournamentService.new()

		-- Setup default tournament data
		mockTournamentDataModule.ReturnTournament.mockReturnValue({
			Number = 1,
			Goal = "Kills",
			MapName = "TestMap",
			ForcedElements = { "Fire", "Water" },
		})

		-- Setup default player data
		mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
			if field == "TournamentsData" then
				return {
					CurrentTournament = 1,
					Bracket = "A",
					Kills = 10,
					Damage = 1000,
					PreviousResults = {},
				}
			end
			return {}
		end)

		-- Setup mock data store responses
		mockDataStore.GetSortedAsync.mockImplementation(function()
			return {
				GetCurrentPage = function()
					return {
						[1] = { key = "12345", value = 100 },
						[2] = { key = "67890", value = 90 },
						[3] = { key = "11111", value = 80 },
					}
				end,
			}
		end)
	end)

	describe("initialization", function()
		it("should create a new TournamentService instance", function()
			expect(tournamentService).toBeDefined()
			expect(tournamentService.version).toEqual({ major = 1, minor = 0, patch = 0 })
		end)

		it("should initialize cache structures", function()
			expect(tournamentService._cachedLeaderboardData).toBeDefined()
			expect(tournamentService._cacheLeaderboardCooldowns).toBeDefined()
		end)

		it("should create events", function()
			expect(tournamentService.tournamentStarted).toBeDefined()
			expect(tournamentService.tournamentCompleted).toBeDefined()
			expect(tournamentService.leaderboardUpdated).toBeDefined()
			expect(tournamentService.rewardClaimed).toBeDefined()
		end)
	end)

	describe("getCurrentTournament", function()
		it("should return current tournament data", function()
			local tournament = tournamentService:getCurrentTournament()
			expect(tournament).toBeDefined()
			expect(tournament.Number).toBe(1)
			expect(tournament.Goal).toBe("Kills")
			expect(tournament.MapName).toBe("TestMap")
		end)
	end)

	describe("calculateRewards", function()
		it("should calculate rank-based rewards for top 15", function()
			-- Mock player is rank 1 (UserId 12345 with value 100)
			local rewards = tournamentService:calculateRewards(mockPerson, "A", 1, {
				Kills = 100,
				Damage = 1000,
			})

			expect(rewards).toBeDefined()
			expect(rewards.Type).toBe("Number")
			expect(rewards.Value).toBe(1)
		end)

		it("should calculate percentage-based rewards for non-top-15", function()
			-- Mock player not in top 15
			mockPlayer.UserId = 99999

			local rewards = tournamentService:calculateRewards(mockPerson, "A", 1, {
				Kills = 50, -- Half of leader's score
				Damage = 1000,
			})

			expect(rewards).toBeDefined()
			expect(rewards.Type).toBe("Percent")
			expect(rewards.Value).toBe(50) -- 50% of leader's score
		end)

		it("should return nil if tournament data not found", function()
			mockTournamentDataModule.ReturnTournament.mockReturnValue(nil)

			local rewards = tournamentService:calculateRewards(mockPerson, "A", 999, {
				Kills = 10,
				Damage = 100,
			})

			expect(rewards).toBeNil()
		end)
	end)

	describe("updatePlayerData", function()
		it("should initialize tournament data for new player", function()
			mockPlayerProfileClass.GetField.mockReturnValue(nil)

			tournamentService:updatePlayerData(mockPerson)

			expect(mockPlayerProfileClass.WriteField).toHaveBeenCalledWith(
				mockPlayerProfileClass,
				"TournamentsData",
				expect.objectContaining({
					Bracket = expect.any("string"),
					Kills = 0,
					Damage = 0,
				}),
				true
			)
		end)

		it("should handle tournament number change", function()
			-- Current tournament is 1, new tournament is 2
			mockTournamentDataModule.ReturnTournament.mockReturnValue({
				Number = 2,
				Goal = "Damage",
				MapName = "NewMap",
			})

			tournamentService:updatePlayerData(mockPerson)

			-- Should fire tournament completed event
			expect(tournamentService.tournamentCompleted.fire).toHaveBeenCalledWith(
				tournamentService.tournamentCompleted,
				mockPerson,
				2
			)
		end)

		it("should ensure valid bracket", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "TournamentsData" then
					return {
						CurrentTournament = 1,
						Bracket = "INVALID", -- Invalid multi-character bracket
						Kills = 10,
						Damage = 1000,
						PreviousResults = {},
					}
				end
				return {}
			end)

			tournamentService:updatePlayerData(mockPerson)

			expect(mockPlayerProfileClass.WriteField).toHaveBeenCalledWith(
				mockPlayerProfileClass,
				"TournamentsData",
				expect.objectContaining({
					Bracket = expect.stringMatching("^[A-Z]$"), -- Single letter A-Z
				}),
				true
			)
		end)
	end)

	describe("updatePlayerLeaderboard", function()
		it("should update player position on leaderboard", function()
			local tournamentData = {
				Bracket = "A",
				Kills = 50,
				Damage = 500,
			}

			tournamentService:updatePlayerLeaderboard(mockPerson, tournamentData)

			expect(mockDataStore.SetAsync).toHaveBeenCalledWith(
				mockDataStore,
				mockPlayer.UserId,
				50 -- Kills value since tournament goal is "Kills"
			)

			expect(tournamentService.leaderboardUpdated.fire).toHaveBeenCalledWith(
				tournamentService.leaderboardUpdated,
				mockPerson,
				"A",
				1
			)
		end)

		it("should use damage value when tournament goal is damage", function()
			mockTournamentDataModule.ReturnTournament.mockReturnValue({
				Number = 1,
				Goal = "Damage",
				MapName = "TestMap",
			})

			local tournamentData = {
				Bracket = "A",
				Kills = 50,
				Damage = 500,
			}

			tournamentService:updatePlayerLeaderboard(mockPerson, tournamentData)

			expect(mockDataStore.SetAsync).toHaveBeenCalledWith(
				mockDataStore,
				mockPlayer.UserId,
				500 -- Damage value since tournament goal is "Damage"
			)
		end)
	end)

	describe("getLeaderboardData", function()
		it("should return cached leaderboard data", function()
			tournamentService._cachedLeaderboardData["A"] = {
				[1] = { UserId = 12345, Value = 100 },
				[2] = { UserId = 67890, Value = 90 },
			}

			local leaderboard = tournamentService:getLeaderboardData("A")
			expect(leaderboard).toEqual({
				[1] = { UserId = 12345, Value = 100 },
				[2] = { UserId = 67890, Value = 90 },
			})
		end)

		it("should trigger cache update if data not available", function()
			local leaderboard = tournamentService:getLeaderboardData("B")
			expect(leaderboard).toEqual({})

			-- Should set cooldown
			expect(tournamentService._cacheLeaderboardCooldowns["B"]).toBe(true)
		end)
	end)

	describe("getTournamentRank", function()
		it("should return player rank if found", function()
			tournamentService._cachedLeaderboardData["A"] = {
				[1] = { UserId = 12345, Value = 100 },
				[2] = { UserId = 67890, Value = 90 },
			}

			local rank = tournamentService:getTournamentRank(mockPerson)
			expect(rank).toEqual({
				Rank = 1,
				Value = 100,
			})
		end)

		it("should return '<100' if player not in top rankings", function()
			tournamentService._cachedLeaderboardData["A"] = {
				[1] = { UserId = 99999, Value = 100 },
				[2] = { UserId = 88888, Value = 90 },
			}

			local rank = tournamentService:getTournamentRank(mockPerson)
			expect(rank).toBe("<100")
		end)

		it("should return '<100' if no tournament data", function()
			mockPlayerProfileClass.GetField.mockReturnValue(nil)

			local rank = tournamentService:getTournamentRank(mockPerson)
			expect(rank).toBe("<100")
		end)
	end)

	describe("startTournament", function()
		it("should start tournament successfully", function()
			local result = tournamentService:startTournament(mockPerson)
			expect(result.success).toBe(true)

			expect(tournamentService.tournamentStarted.fire).toHaveBeenCalledWith(
				tournamentService.tournamentStarted,
				mockPerson,
				1
			)
		end)

		it("should fail if no active tournament", function()
			mockTournamentDataModule.ReturnTournament.mockReturnValue(nil)

			local result = tournamentService:startTournament(mockPerson)
			expect(result.success).toBe(false)
			expect(result.error).toBe("No active tournament")
		end)

		it("should update player data if tournament changed", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "TournamentsData" then
					return {
						CurrentTournament = 999, -- Different from current tournament (1)
						Bracket = "A",
						Kills = 10,
						Damage = 1000,
						PreviousResults = {},
					}
				end
				return {}
			end)

			local result = tournamentService:startTournament(mockPerson)
			expect(result.success).toBe(false)
			expect(result.error).toBe("Tournament data updated, please try again")
		end)
	end)

	describe("updateStats", function()
		it("should update tournament stats with maximum values", function()
			local tournamentData = {
				CurrentTournament = 1,
				Bracket = "A",
				Kills = 5,
				Damage = 100,
				PreviousResults = {},
			}

			mockPlayerProfileClass.GetField.mockReturnValue(tournamentData)

			tournamentService:updateStats(mockPerson, 10, 50)

			expect(mockPlayerProfileClass.WriteField).toHaveBeenCalledWith(
				mockPlayerProfileClass,
				"TournamentsData",
				expect.objectContaining({
					Kills = 10, -- Updated to higher value
					Damage = 100, -- Kept higher existing value
				}),
				true
			)
		end)
	end)

	describe("claimRewards", function()
		it("should claim tournament rewards successfully", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "TournamentsData" then
					return {
						CurrentTournament = 2,
						Bracket = "A",
						Kills = 10,
						Damage = 1000,
						PreviousResults = {
							[1] = {
								Bracket = "A",
								Kills = 50,
								Damage = 500,
								ClaimedRewards = false,
								RewardsToClaim = {
									Type = "Number",
									Value = 3,
								},
							},
						},
					}
				end
				return {}
			end)

			local result = tournamentService:claimRewards(mockPerson, 1)
			expect(result.success).toBe(true)
			expect(result.rewards).toEqual({ gems = 100 })

			expect(tournamentService.rewardClaimed.fire).toHaveBeenCalledWith(
				tournamentService.rewardClaimed,
				mockPerson,
				1,
				{ gems = 100 }
			)
		end)

		it("should fail if rewards already claimed", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "TournamentsData" then
					return {
						CurrentTournament = 2,
						PreviousResults = {
							[1] = {
								Bracket = "A",
								Kills = 50,
								Damage = 500,
								ClaimedRewards = true, -- Already claimed
								RewardsToClaim = {
									Type = "Number",
									Value = 3,
								},
							},
						},
					}
				end
				return {}
			end)

			local result = tournamentService:claimRewards(mockPerson, 1)
			expect(result.success).toBe(false)
			expect(result.error).toBe("Rewards already claimed")
		end)

		it("should fail if no rewards available", function()
			mockPlayerProfileClass.GetField.mockImplementation(function(_, field)
				if field == "TournamentsData" then
					return {
						CurrentTournament = 2,
						PreviousResults = {
							[1] = {
								Bracket = "A",
								Kills = 50,
								Damage = 500,
								ClaimedRewards = false,
								RewardsToClaim = nil, -- No rewards
							},
						},
					}
				end
				return {}
			end)

			local result = tournamentService:claimRewards(mockPerson, 1)
			expect(result.success).toBe(false)
			expect(result.error).toBe("No rewards available")
		end)
	end)
end)
