--------------------------------------------------------------------------------
-- Receipt Processor Tests
-- Tests the receipt processor system functionality and data validation
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Data = require("@commonserver/data")
local ReceiptProcessor = require("@commonserver/receipt_processor")

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

describe("ReceiptProcessor", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(ReceiptProcessor).toBeDefined()
			expect(ReceiptProcessor.version).toBeDefined()
			expect(typeof(ReceiptProcessor.version)).toBe("table")
		end)

		it("should have required functions", function()
			expect(ReceiptProcessor.init).toBeDefined()
			expect(typeof(ReceiptProcessor.init)).toBe("function")
		end)
	end)

	describe("Receipt Processing Functionality", function()
		it("should initialize without errors", function()
			expect(function()
				ReceiptProcessor.init()
			end).never.toThrow()
		end)
	end)

	describe("Data Validation", function()
		it("should have valid receipt history data template fields", function()
			local template = Data.template
			expect(template.ReceiptHistory).toBeDefined()
			expect(typeof(template.ReceiptHistory)).toBe("table")
		end)

		it("should validate person's receipt history data", function()
			local personData = MockPerson.dataCache()
			expect(personData.ReceiptHistory).toBeDefined()
			expect(typeof(personData.ReceiptHistory)).toBe("table")
		end)
	end)
end)
