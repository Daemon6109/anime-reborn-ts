--------------------------------------------------------------------------------
-- Advent Calendar Tests
-- Tests the advent calendar system functionality
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local atom = Charm.atom

-- Import modules to test
local AdventCalendar = require("@commonserver/advent_calendar")
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
	dataCache = atom(Data.template),
	sessionData = {
		Kills = {
			Value = atom(0),
			Leaderboard = true,
			Name = "Kills 🗡️",
		},
	},
	Dispose = function(self) end,
}

describe("AdventCalendar", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(AdventCalendar).toBeDefined()
			expect(AdventCalendar.version).toBeDefined()
			expect(typeof(AdventCalendar.version)).toBe("table")
		end)

		it("should have required functions", function()
			expect(AdventCalendar.getCurrentDay).toBeDefined()
			expect(AdventCalendar.getClaimedDays).toBeDefined()
			expect(AdventCalendar.getOnlineDays).toBeDefined()
			expect(AdventCalendar.canClaimAdventReward).toBeDefined()
			expect(typeof(AdventCalendar.getCurrentDay)).toBe("function")
			expect(typeof(AdventCalendar.getClaimedDays)).toBe("function")
		end)

		it("should have event signals", function()
			expect(AdventCalendar.dayUnlocked).toBeDefined()
			expect(AdventCalendar.rewardClaimed).toBeDefined()
			expect(AdventCalendar.calendarEnded).toBeDefined()
		end)
	end)

	describe("Calendar Functionality", function()
		it("should handle getCurrentDay without errors", function()
			expect(function()
				AdventCalendar:getCurrentDay()
			end).never.toThrow()
		end)

		it("should handle getClaimedDays for person", function()
			expect(function()
				AdventCalendar:getClaimedDays(MockPerson)
			end).never.toThrow()
		end)

		it("should handle getOnlineDays for person", function()
			expect(function()
				AdventCalendar:getOnlineDays(MockPerson)
			end).never.toThrow()
		end)

		it("should handle canClaimAdventReward for person", function()
			expect(function()
				local canClaim = AdventCalendar:canClaimAdventReward(MockPerson, 1)
				expect(typeof(canClaim)).toBe("boolean")
			end).never.toThrow()
		end)
	end)

	describe("Data Validation", function()
		it("should have valid data template fields", function()
			local template = Data.template
			expect(template.AdventCalendarData).toBeDefined()
			expect(typeof(template.AdventCalendarData)).toBe("table")

			-- Check for required fields in advent calendar data
			local acData = template.AdventCalendarData
			expect(acData.DayNumber).toBeDefined()
			expect(typeof(acData.DayNumber)).toBe("number")
		end)

		it("should validate person's advent calendar data", function()
			local personData = MockPerson.dataCache()
			expect(personData.AdventCalendarData).toBeDefined()
			expect(typeof(personData.AdventCalendarData)).toBe("table")
		end)
	end)
end)
