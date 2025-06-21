--------------------------------------------------------------------------------
-- Team Events Tests
-- Tests the team events system functionality and data validation
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Data = require("@commonserver/data")
local TeamEvents = require("@commonserver/team_events")

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

describe("TeamEvents", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(TeamEvents).toBeDefined()
			expect(TeamEvents.version).toBeDefined()
			expect(typeof(TeamEvents.version)).toBe("table")
		end)

		it("should have required functions", function()
			expect(TeamEvents.awardTeamReaperParts).toBeDefined()
			expect(TeamEvents.getCurrentTeam).toBeDefined()
			expect(TeamEvents.getTeamRankings).toBeDefined()
			expect(typeof(TeamEvents.awardTeamReaperParts)).toBe("function")
			expect(typeof(TeamEvents.getCurrentTeam)).toBe("function")
			expect(typeof(TeamEvents.getTeamRankings)).toBe("function")
		end)
	end)

	describe("Team Events Functionality", function()
		it("should award team reaper parts without errors", function()
			expect(function()
				TeamEvents.awardTeamReaperParts(MockPerson, 10, "test reason")
			end).never.toThrow()
		end)

		it("should get current team without errors", function()
			expect(function()
				TeamEvents.getCurrentTeam(MockPerson)
			end).never.toThrow()
		end)

		it("should get team rankings without errors", function()
			expect(function()
				TeamEvents.getTeamRankings()
			end).never.toThrow()
		end)
	end)

	describe("Data Validation", function()
		it("should have valid team event data template fields", function()
			local template = Data.template
			expect(template.TeamEventData).toBeDefined()
			expect(typeof(template.TeamEventData)).toBe("table")
			expect(template.Teams).toBeDefined()
			expect(typeof(template.Teams)).toBe("table")
		end)

		it("should validate person's team event data", function()
			local personData = MockPerson.dataCache()
			expect(personData.TeamEventData).toBeDefined()
			expect(typeof(personData.TeamEventData)).toBe("table")
			expect(personData.Teams).toBeDefined()
			expect(typeof(personData.Teams)).toBe("table")
		end)
	end)
end)
