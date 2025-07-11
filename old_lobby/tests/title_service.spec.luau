--------------------------------------------------------------------------------
-- title_service.spec
-- Tests the title service functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local jest = JestGlobals.jest

-- Import modules to test
local TitleService = require("@server/title_service")

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
	dataCache = function(updateFn)
		if updateFn then
			return updateFn({
				Inventory = { Titles = { "TestTitle", "AnotherTitle" } },
				CurrentTitle = "",
			})
		else
			return {
				Inventory = { Titles = { "TestTitle", "AnotherTitle" } },
				CurrentTitle = "",
			}
		end
	end,
}

describe("TitleService", function()
	beforeEach(function()
		-- Reset any state before each test
	end)

	describe("equipTitle", function()
		it("should equip a title when player owns it", function()
			local success = TitleService.equipTitle(MockPerson, "TestTitle")
			expect(success).toBe(true)
		end)

		it("should fail to equip a title when player doesn't own it", function()
			local success = TitleService.equipTitle(MockPerson, "UnownedTitle")
			expect(success).toBe(false)
		end)

		it("should return false for empty title name", function()
			local success = TitleService.equipTitle(MockPerson, "")
			expect(success).toBe(false)
		end)
	end)

	describe("awardTitle", function()
		it("should award a new title to player", function()
			local success = TitleService.awardTitle(MockPerson, "NewTitle")
			expect(success).toBe(true)
		end)

		it("should not award a title player already owns", function()
			local success = TitleService.awardTitle(MockPerson, "TestTitle")
			expect(success).toBe(false)
		end)
	end)

	describe("getPlayerTitles", function()
		it("should return player's titles", function()
			local titles = TitleService.getPlayerTitles(MockPerson)
			expect(#titles).toBe(2)
			expect(table.find(titles, "TestTitle")).toBeTruthy()
			expect(table.find(titles, "AnotherTitle")).toBeTruthy()
		end)

		it("should return empty array for player with no titles", function()
			local mockPersonNoTitles = {
				player = MockPlayer,
				dataCache = function()
					return { Inventory = { Titles = {} } }
				end,
			}
			local titles = TitleService.getPlayerTitles(mockPersonNoTitles)
			expect(#titles).toBe(0)
		end)
	end)

	describe("getCurrentTitle", function()
		it("should return current title", function()
			local mockPersonWithTitle = {
				player = MockPlayer,
				dataCache = function()
					return { CurrentTitle = "Champion" }
				end,
			}
			local title = TitleService.getCurrentTitle(mockPersonWithTitle)
			expect(title).toBe("Champion")
		end)

		it("should return empty string when no title equipped", function()
			local title = TitleService.getCurrentTitle(MockPerson)
			expect(title).toBe("")
		end)
	end)

	describe("unequipTitle", function()
		it("should unequip current title", function()
			local mockPersonWithTitle = {
				player = MockPlayer,
				dataCache = function(updateFn)
					if updateFn then
						return updateFn({ CurrentTitle = "Champion" })
					else
						return { CurrentTitle = "Champion" }
					end
				end,
			}

			-- Should not throw
			expect(function()
				TitleService.unequipTitle(mockPersonWithTitle)
			end).never.toThrow()
		end)
	end)

	describe("version", function()
		it("should have a valid version", function()
			expect(TitleService.version).toBeDefined()
			expect(TitleService.version.major).toBe(1)
			expect(TitleService.version.minor).toBe(0)
			expect(TitleService.version.patch).toBe(0)
		end)
	end)

	describe("events", function()
		it("should have title events", function()
			expect(TitleService.titleEquipped).toBeDefined()
			expect(TitleService.titleAwarded).toBeDefined()
		end)
	end)
end)
