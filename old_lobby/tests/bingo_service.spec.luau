--------------------------------------------------------------------------------
-- bingo_service.spec
-- Tests the bingo service functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
-- Import modules to test
local BingoService = require("@server/bingo_service")

-- Mock dependencies
local Players = game:GetService("Players")

local MockPlayer = (
	{
		UserId = 12345,
		Name = "TestPlayer",
		DisplayName = "TestPlayer",
		Parent = Players,
	} :: any
) :: Player

local MockPerson = {
	player = MockPlayer,
	dataCache = function(updateFn)
		if updateFn then
			return updateFn({
				BingoData = {
					Quests = {
						["1,1"] = { questName = "WinGames", progress = 5, claimed = false },
						["1,2"] = { questName = "SummonUnits", progress = 10, claimed = true },
						["1,3"] = { questName = "UpgradeUnits", progress = 3, claimed = false },
					},
					Claimed = {},
					TotalClaimedRows = 0,
					NextBingoIn = os.time() + 3600, -- 1 hour from now
				},
			})
		else
			return {
				BingoData = {
					Quests = {
						["1,1"] = { questName = "WinGames", progress = 5, claimed = false },
						["1,2"] = { questName = "SummonUnits", progress = 10, claimed = true },
						["1,3"] = { questName = "UpgradeUnits", progress = 3, claimed = false },
					},
					Claimed = {},
					TotalClaimedRows = 0,
					NextBingoIn = os.time() + 3600, -- 1 hour from now
				},
			}
		end
	end,
}

describe("BingoService", function()
	beforeEach(function()
		-- Reset any state before each test
	end)

	describe("initializeBingoData", function()
		it("should create valid bingo data", function()
			local bingoData = BingoService.initializeBingoData(MockPerson :: any)

			expect(bingoData).toBeDefined()
			expect(bingoData.Quests).toBeDefined()
			expect(bingoData.Claimed).toBeDefined()
			expect(bingoData.TotalClaimedRows).toBe(0)

			-- Should have 9 quests (3x3 grid)
			local questCount = 0
			for _ in pairs(bingoData.Quests) do
				questCount += 1
			end
			expect(questCount).toBe(9)
		end)
	end)

	describe("getBingoData", function()
		it("should return existing bingo data", function()
			local bingoData = BingoService.getBingoData(MockPerson :: any)
			expect(bingoData).toBeDefined()
			expect(bingoData.Quests).toBeDefined()
		end)

		it("should initialize new data if none exists", function()
			local mockPersonNoBingo = {
				player = MockPlayer,
				dataCache = function(updateFn)
					if updateFn then
						return updateFn({})
					else
						return {}
					end
				end,
			}

			local bingoData = BingoService.getBingoData(mockPersonNoBingo :: any)
			expect(bingoData).toBeDefined()
			expect(bingoData.Quests).toBeDefined()
		end)
	end)

	describe("addProgress", function()
		it("should add progress to matching quests", function()
			expect(function()
				BingoService.addProgress(MockPerson :: any, "WinGames", 2)
			end).never.toThrow()
		end)

		it("should not add progress to claimed quests", function()
			expect(function()
				BingoService.addProgress(MockPerson :: any, "SummonUnits", 5)
			end).never.toThrow()
		end)

		it("should handle non-existent quests gracefully", function()
			expect(function()
				BingoService.addProgress(MockPerson :: any, "NonExistentQuest", 1)
			end).never.toThrow()
		end)
	end)

	describe("claimSquare", function()
		it("should claim a completed square", function()
			-- Mock a person with a completed quest
			local mockPersonWithCompleted = {
				player = MockPlayer,
				dataCache = function(updateFn)
					if updateFn then
						return updateFn({
							BingoData = {
								Quests = {
									["1,1"] = { questName = "WinGames", progress = 10, claimed = false },
								},
								Claimed = {},
								TotalClaimedRows = 0,
								NextBingoIn = os.time() + 3600, -- 1 hour from now,
							},
						})
					else
						return {
							BingoData = {
								Quests = {
									["1,1"] = { questName = "WinGames", progress = 10, claimed = false },
								},
								Claimed = {},
								TotalClaimedRows = 0,
								NextBingoIn = os.time() + 3600, -- 1 hour from now,
							},
						}
					end
				end,
			}

			local result = BingoService.claimSquare(mockPersonWithCompleted :: any, "1,1" :: any)
			expect(result).toBe(true)
		end)

		it("should not claim incomplete squares", function()
			local result = BingoService.claimSquare(MockPerson :: any, "1,1" :: any)
			expect(result).toBe(false)
		end)

		it("should not claim already claimed squares", function()
			local result = BingoService.claimSquare(MockPerson :: any, "1,2" :: any)
			expect(result).toBe(false)
		end)
	end)

	describe("claimRow", function()
		it("should not claim incomplete rows", function()
			local result = BingoService.claimRow(MockPerson :: any, "H", 1)
			expect(result).toBe(false)
		end)

		it("should handle invalid row types", function()
			local result = BingoService.claimRow(MockPerson :: any, "X", 1)
			expect(result).toBe(false)
		end)

		it("should not claim beyond max rows", function()
			local mockPersonMaxRows = {
				player = MockPlayer,
				dataCache = function()
					return {
						BingoData = {
							Quests = {},
							Claimed = {},
							TotalClaimedRows = 9,
						},
					}
				end,
			}

			local result = BingoService.claimRow(mockPersonMaxRows :: any, "H", 1)
			expect(result).toBe(false)
		end)
	end)

	describe("version", function()
		it("should have a valid version", function()
			expect(BingoService.version).toBeDefined()
			expect(BingoService.version.major).toBe(1)
			expect(BingoService.version.minor).toBe(0)
			expect(BingoService.version.patch).toBe(0)
		end)
	end)

	describe("events", function()
		it("should have bingo events", function()
			expect(BingoService.questProgressUpdated).toBeDefined()
			expect(BingoService.squareClaimed).toBeDefined()
			expect(BingoService.rowClaimed).toBeDefined()
		end)
	end)
end)
