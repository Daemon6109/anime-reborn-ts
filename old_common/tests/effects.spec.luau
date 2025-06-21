--------------------------------------------------------------------------------
-- Effects Tests
-- Tests the effects system functionality and data validation
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Data = require("@commonserver/data")
local Effects = require("@commonserver/effects")

-- Mock dependencies
local Players = game:GetService("Players")

local MockPlayer = (
	{
		UserId = 12345,
		Name = "TestPlayer",
		DisplayName = "TestPlayer",
		Parent = Players,
		CharacterAdded = {
			Connect = function(self, callback)
				return { Disconnect = function() end }
			end,
		},
	} :: any
) :: Player

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

describe("Effects", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)
	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(Effects).toBeDefined()
			expect(Effects.version).toBeDefined()
			expect(typeof(Effects.version)).toBe("table")
		end)
		it("should have required methods", function()
			expect(Effects.ApplyEffect).toBeDefined()
			expect(Effects.GetAllActiveEffects).toBeDefined()
			expect(Effects.IsEffectActive).toBeDefined()
			expect(Effects.CalculateMultiplier).toBeDefined()
			expect(typeof(Effects.ApplyEffect)).toBe("function")
			expect(typeof(Effects.GetAllActiveEffects)).toBe("function")
			expect(typeof(Effects.IsEffectActive)).toBe("function")
			expect(typeof(Effects.CalculateMultiplier)).toBe("function")
		end)
	end)
	describe("Effects Functionality", function()
		it("should apply effects without errors", function()
			expect(function()
				Effects:ApplyEffect(MockPerson, "Exp", 60)
			end).never.toThrow()
		end)
		it("should get all active effects", function()
			local activeEffects = Effects:GetAllActiveEffects(MockPerson)
			expect(typeof(activeEffects)).toBe("table")
		end)
		it("should check if effect is active", function()
			local isActive = Effects:IsEffectActive(MockPerson, "Exp")
			expect(typeof(isActive)).toBe("boolean")
		end)
		it("should calculate multiplier", function()
			local multiplier = Effects:CalculateMultiplier(MockPerson, "Exp")
			expect(typeof(multiplier)).toBe("number")
		end)
	end)
	describe("Data Validation", function()
		it("should have valid effects data template fields", function()
			local template = Data.template
			expect(template.Effects).toBeDefined()
			expect(typeof(template.Effects)).toBe("table")
		end)
		it("should validate person's effects data", function()
			local personData = MockPerson.dataCache()
			expect(personData.Effects).toBeDefined()
			expect(typeof(personData.Effects)).toBe("table")
		end)
	end)
end)
