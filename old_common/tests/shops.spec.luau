--------------------------------------------------------------------------------
-- Shops Tests
-- Tests the shops system functionality
--------------------------------------------------------------------------------

local Charm = require("@pkgs/charm")
local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

-- Import modules to test
local Data = require("@commonserver/data")
local Shops = require("@commonserver/shops")

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

describe("Shops", function()
	beforeEach(function()
		-- Initialize the data system
		Data.init()
	end)

	describe("Module Structure", function()
		it("should load and have basic structure", function()
			expect(Shops).toBeDefined()
			expect(Shops.version).toBeDefined()
			expect(typeof(Shops.version)).toBe("table")
		end)

		it("should have required functions", function()
			expect(Shops.checkShopResets).toBeDefined()
			expect(Shops.getShopItems).toBeDefined()
			expect(typeof(Shops.checkShopResets)).toBe("function")
			expect(typeof(Shops.getShopItems)).toBe("function")
		end)
	end)

	describe("Shops Functionality", function()
		it("should check shop resets without errors", function()
			expect(function()
				Shops.checkShopResets()
			end).never.toThrow()
		end)

		it("should get shop items", function()
			local shopItems = Shops.getShopItems("test_shop")
			expect(shopItems == nil or typeof(shopItems) == "table").toBe(true)
		end)
	end)

	describe("Data Validation", function()
		it("should have valid shop data template fields", function()
			local template = Data.template
			-- Check for shop-related data fields
			expect(template.EventShopData).toBeDefined()
			expect(typeof(template.EventShopData)).toBe("table")
			expect(template.RaidShopData).toBeDefined()
			expect(typeof(template.RaidShopData)).toBe("table")
			expect(template.DungeonShopData).toBeDefined()
			expect(typeof(template.DungeonShopData)).toBe("table")
		end)

		it("should validate person's shop data", function()
			local personData = MockPerson.dataCache()
			expect(personData.EventShopData).toBeDefined()
			expect(typeof(personData.EventShopData)).toBe("table")
			expect(personData.RaidShopData).toBeDefined()
			expect(typeof(personData.RaidShopData)).toBe("table")
			expect(personData.DungeonShopData).toBeDefined()
			expect(typeof(personData.DungeonShopData)).toBe("table")
		end)
	end)
end)
