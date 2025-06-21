--------------------------------------------------------------------------------
-- Battlepass Tests
-- Tests the battlepass system functionality and data validation
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Battlepass = require("@commonserver/battlepass")
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

describe("Battlepass", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(Battlepass).toBeDefined()
			expect(Battlepass.version).toBeDefined()
			expect(typeof(Battlepass.version)).toBe("table")
		end)

		it("should have required functions", function()
			expect(Battlepass.addBattlepassXP).toBeDefined()
			expect(Battlepass.hasPremium).toBeDefined()
			expect(Battlepass.getCurrentTier).toBeDefined()
			expect(Battlepass.getCurrentXP).toBeDefined()
			expect(typeof(Battlepass.addBattlepassXP)).toBe("function")
			expect(typeof(Battlepass.hasPremium)).toBe("function")
			expect(typeof(Battlepass.getCurrentTier)).toBe("function")
			expect(typeof(Battlepass.getCurrentXP)).toBe("function")
		end)
	end)

	describe("Battlepass Functionality", function()
		it("should handle addBattlepassXP without errors", function()
			expect(function()
				Battlepass.addBattlepassXP(MockPerson, 100)
			end).never.toThrow()
		end)

		it("should check premium status", function()
			local hasPremium = Battlepass.hasPremium(MockPerson)
			expect(typeof(hasPremium)).toBe("boolean")
		end)

		it("should get current tier", function()
			local currentTier = Battlepass.getCurrentTier(MockPerson)
			expect(typeof(currentTier)).toBe("number")
		end)

		it("should get current XP", function()
			local currentXP = Battlepass.getCurrentXP(MockPerson)
			expect(typeof(currentXP)).toBe("number")
		end)
	end)

	describe("Data Validation", function()
		it("should have valid battlepass data template fields", function()
			local template = Data.template
			expect(template.BattlepassData).toBeDefined()
			expect(typeof(template.BattlepassData)).toBe("table")

			-- Check for required fields in battlepass data
			local bpData = template.BattlepassData
			expect(bpData.Level).toBeDefined()
			expect(typeof(bpData.Level)).toBe("number")
			expect(bpData.Exp).toBeDefined()
			expect(typeof(bpData.Exp)).toBe("number")
			expect(bpData.HasPremium).toBeDefined()
			expect(typeof(bpData.HasPremium)).toBe("boolean")
			expect(bpData.ResetExp).toBeDefined()
			expect(typeof(bpData.ResetExp)).toBe("boolean")
			expect(bpData.ClaimedFree).toBeDefined()
			expect(typeof(bpData.ClaimedFree)).toBe("number")
			expect(bpData.ClaimedPremium).toBeDefined()
			expect(typeof(bpData.ClaimedPremium)).toBe("number")
			expect(bpData.BattlepassName).toBeDefined()
			expect(typeof(bpData.BattlepassName)).toBe("string")
		end)

		it("should validate person's battlepass data", function()
			local personData = MockPerson.dataCache()
			expect(personData.BattlepassData).toBeDefined()
			expect(typeof(personData.BattlepassData)).toBe("table")

			local bpData = personData.BattlepassData
			expect(bpData.Level).toBeDefined()
			expect(bpData.Exp).toBeDefined()
			expect(bpData.HasPremium).toBeDefined()
		end)
	end)
end)
