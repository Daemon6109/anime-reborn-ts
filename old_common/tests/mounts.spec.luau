--------------------------------------------------------------------------------
-- Mounts Tests
-- Tests the mounts system functionality and data validation
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Data = require("@commonserver/data")
local Mounts = require("@commonserver/mounts")

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

describe("Mounts", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(Mounts).toBeDefined()
			expect(Mounts.version).toBeDefined()
			expect(typeof(Mounts.version)).toBe("table")
		end)

		it("should have required functions", function()
			expect(Mounts.equipMount).toBeDefined()
			expect(Mounts.unequipMount).toBeDefined()
			expect(typeof(Mounts.equipMount)).toBe("function")
			expect(typeof(Mounts.unequipMount)).toBe("function")
		end)
	end)

	describe("Mounts Functionality", function()
		it("should handle equipMount", function()
			local canEquip = Mounts.equipMount(MockPerson, "TestMount")
			expect(typeof(canEquip)).toBe("boolean")
		end)

		it("should handle unequipMount without errors", function()
			expect(function()
				Mounts.unequipMount(MockPerson)
			end).never.toThrow()
		end)
	end)

	describe("Data Validation", function()
		it("should work with current data template", function()
			local template = Data.template
			expect(template.EquippedMount).toBeDefined()
			expect(typeof(template.EquippedMount)).toBe("string")
		end)

		it("should validate person's mount data", function()
			local personData = MockPerson.dataCache()
			expect(personData.EquippedMount).toBeDefined()
			expect(typeof(personData.EquippedMount)).toBe("string")
		end)
	end)
end)
