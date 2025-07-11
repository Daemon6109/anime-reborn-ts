--------------------------------------------------------------------------------
-- leaderboard_service.spec
-- Tests the leaderboard service functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local jest = JestGlobals.jest

-- Import modules to test
local LeaderboardService = require("@server/leaderboard_service")

-- Mock dependencies
local Players = game:GetService("Players")

local MockPlayer = {
	UserId = 12345,
	Name = "TestPlayer",
	DisplayName = "TestPlayer",
	Parent = Players,
} :: Player

local MockPerson = {
	player = MockPlayer,
	dataCache = function()
		return {}
	end,
}

describe("LeaderboardService", function()
	beforeEach(function()
		-- Reset any state before each test
	end)

	describe("formatNumber", function()
		it("should format numbers correctly", function()
			expect(LeaderboardService.formatNumber(500)).toBe("500")
			expect(LeaderboardService.formatNumber(1500)).toBe("1.5K")
			expect(LeaderboardService.formatNumber(1500000)).toBe("1.5M")
			expect(LeaderboardService.formatNumber(1500000000)).toBe("1.5B")
		end)

		it("should handle zero and negative numbers", function()
			expect(LeaderboardService.formatNumber(0)).toBe("0")
			expect(LeaderboardService.formatNumber(-100)).toBe("-100")
		end)

		it("should handle decimal numbers", function()
			expect(LeaderboardService.formatNumber(1234.56)).toBe("1.2K")
		end)
	end)

	describe("getPlayerNameFromUserId", function()
		it("should call callback with player name", function()
			local callbackCalled = false
			local receivedName = ""

			LeaderboardService.getPlayerNameFromUserId(1, function(name)
				callbackCalled = true
				receivedName = name
			end)

			-- Note: This test may not work in a test environment due to HTTP restrictions
			-- In a real test, you'd mock the Players service
			expect(callbackCalled).toBe(true)
			expect(receivedName).toBeDefined()
		end)
	end)

	describe("getPlayerRank", function()
		it("should return rank for valid leaderboard", function()
			-- Note: This would require mocking DataStoreService in a real test
			local result = LeaderboardService.getPlayerRank(MockPerson, "TestLeaderboard", false)
			expect(result).toBeDefined()
		end)

		it("should return detailed rank info when requested", function()
			local result = LeaderboardService.getPlayerRank(MockPerson, "TestLeaderboard", true)
			expect(result).toBeDefined()
		end)
	end)

	describe("updateLeaderboards", function()
		it("should execute without errors", function()
			expect(function()
				LeaderboardService.updateLeaderboards()
			end).never.toThrow()
		end)
	end)

	describe("updatePlayerStat", function()
		it("should execute without errors", function()
			expect(function()
				LeaderboardService.updatePlayerStat(MockPerson, "TestLeaderboard", 100)
			end).never.toThrow()
		end)
	end)

	describe("version", function()
		it("should have a valid version", function()
			expect(LeaderboardService.version).toBeDefined()
			expect(LeaderboardService.version.major).toBe(1)
			expect(LeaderboardService.version.minor).toBe(0)
			expect(LeaderboardService.version.patch).toBe(0)
		end)
	end)

	describe("events", function()
		it("should have leaderboard events", function()
			expect(LeaderboardService.leaderboardUpdated).toBeDefined()
			expect(LeaderboardService.playerRankChanged).toBeDefined()
		end)
	end)
end)
