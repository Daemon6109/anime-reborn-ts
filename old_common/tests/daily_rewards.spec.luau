--------------------------------------------------------------------------------
-- Daily Rewards Tests
-- Tests the daily rewards system functionality and data validation
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local DailyRewards = require("@commonserver/daily_rewards")
local Data = require("@commonserver/data")

-- Mock dependencies
local Players = game:GetService("Players")

local MockPlayer = {
	UserId = 12345,
	Name = "TestPlayer",
	DisplayName = "TestPlayer",
	Parent = Players,
	CharacterAdded = {
		Connect = function(self, callback)
			return { Disconnect = function() end }
		end,
	},
} :: Player

local MockPerson = {
	player = MockPlayer,
	dataCache = Charm.atom(Data.template),
	sessionData = {
		Kills = {
			Value = Charm.atom(0),
			Leaderboard = true,
			Name = "Kills 🗡️",
		},
	},
	Dispose = function(self) end,
}

describe("DailyRewards", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(DailyRewards).toBeDefined()
			expect(DailyRewards.version).toBeDefined()
			expect(typeof(DailyRewards.version)).toBe("table")
		end)

		it("should have required functions", function()
			expect(DailyRewards.claimDailyReward).toBeDefined()
			expect(DailyRewards.getDailyStatus).toBeDefined()
			expect(typeof(DailyRewards.claimDailyReward)).toBe("function")
			expect(typeof(DailyRewards.getDailyStatus)).toBe("function")
		end)
	end)

	describe("Daily Rewards Functionality", function()
		it("should handle claimDailyReward", function()
			local canClaim = DailyRewards.claimDailyReward(MockPerson)
			expect(typeof(canClaim)).toBe("boolean")
		end)

		it("should get daily status", function()
			local status = DailyRewards.getDailyStatus(MockPerson)
			expect(typeof(status)).toBe("table")
			expect(status.canClaim).toBeDefined()
			expect(status.currentDay).toBeDefined()
			expect(status.totalClaimed).toBeDefined()
		end)
	end)

	describe("Data Validation", function()
		it("should have valid daily rewards data template fields", function()
			local template = Data.template
			expect(template.DailyRewardsData).toBeDefined()
			expect(typeof(template.DailyRewardsData)).toBe("table")

			-- Check for required fields in daily rewards data
			local drData = template.DailyRewardsData
			expect(drData.LastClaimedDay).toBeDefined()
			expect(drData.CurrentStreak).toBeDefined()
			expect(typeof(drData.CurrentStreak)).toBe("number")
			expect(drData.CanClaim).toBeDefined()
			expect(typeof(drData.CanClaim)).toBe("boolean")
			expect(drData.TotalClaimed).toBeDefined()
			expect(typeof(drData.TotalClaimed)).toBe("number")
		end)

		it("should validate person's daily rewards data", function()
			local personData = MockPerson.dataCache()
			expect(personData.DailyRewardsData).toBeDefined()
			expect(typeof(personData.DailyRewardsData)).toBe("table")

			local drData = personData.DailyRewardsData
			expect(drData.CurrentStreak).toBeDefined()
			expect(drData.CanClaim).toBeDefined()
			expect(drData.TotalClaimed).toBeDefined()
		end)
	end)
end)
