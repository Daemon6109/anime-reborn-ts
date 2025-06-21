--------------------------------------------------------------------------------
-- Analytics Tests
-- Tests the analytics system functionality
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Analytics = require("@commonserver/analytics")
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
	dataCache = function()
		return Data.template
	end,
	sessionData = {
		Kills = {
			Value = Charm.atom(0),
			Leaderboard = true,
			Name = "Kills 🗡️",
		},
	},
	Dispose = function(self) end,
}

describe("Analytics", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(Analytics).toBeDefined()
			expect(Analytics.version).toBeDefined()
			expect(typeof(Analytics.version)).toBe("table")
		end)

		it("should have tracking functions", function()
			expect(Analytics.trackPlayerJoined).toBeDefined()
			expect(Analytics.trackPlayerLeft).toBeDefined()
			expect(Analytics.trackCharacterAdded).toBeDefined()
			expect(Analytics.trackEvent).toBeDefined()
			expect(Analytics.trackError).toBeDefined()
			expect(Analytics.trackPerformance).toBeDefined()
			expect(typeof(Analytics.trackPlayerJoined)).toBe("function")
			expect(typeof(Analytics.trackPlayerLeft)).toBe("function")
		end)

		it("should have session data functions", function()
			expect(Analytics.getSessionData).toBeDefined()
			expect(typeof(Analytics.getSessionData)).toBe("function")
		end)
	end)
	describe("Player Tracking", function()
		it("should track player events without errors", function()
			expect(function()
				Analytics.trackPlayerJoined(MockPerson)
			end).never.toThrow()

			expect(function()
				Analytics.trackPlayerLeft(MockPlayer)
			end).never.toThrow()

			expect(function()
				Analytics.trackCharacterAdded(MockPlayer)
			end).never.toThrow()

			expect(function()
				Analytics.trackEvent(MockPlayer, "test_event", { data = "test" })
			end).never.toThrow()

			expect(function()
				Analytics.trackError("Test error", "Test")
			end).never.toThrow()

			expect(function()
				Analytics.trackPerformance(MockPerson)
			end).never.toThrow()
		end)

		it("should get session data", function()
			-- First track a person join to create session data
			Analytics.trackPlayerJoined(MockPerson)
			local sessionData = Analytics.getSessionData(MockPlayer)
			expect(sessionData).toBeDefined()
			if sessionData then
				expect(sessionData.joinTime).toBeDefined()
				expect(sessionData.lastActivity).toBeDefined()
				expect(sessionData.sessionDuration).toBeDefined()
			end
		end)
	end)
	describe("Data Validation", function()
		it("should work with current data template", function()
			local template = Data.template
			expect(template).toBeDefined()
			expect(typeof(template)).toBe("table")

			-- Analytics should work with the person object structure
			local personData = MockPerson.dataCache()
			expect(personData).toBeDefined()
			expect(typeof(personData)).toBe("table")

			-- Check that PlayerStatistics fields exist as expected
			expect(personData.PlayerStatistics).toBeDefined()
			expect(personData.PlayerStatistics.PlayTime).toBeDefined()
			expect(personData.PlayerStatistics.GamesPlayed).toBeDefined()
			expect(personData.Level).toBeDefined()
		end)
	end)
end)
