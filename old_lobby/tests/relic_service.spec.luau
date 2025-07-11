--------------------------------------------------------------------------------
-- relic_service.spec
-- Tests the relic service functionality
--------------------------------------------------------------------------------

local JestGlobals = require("@devpkgs/jest-globals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local jest = JestGlobals.jest

-- Import modules to test
local RelicService = require("@server/relic_service")

-- Mock dependencies
local Players = game:GetService("Players")

local MockPlayer = {
	UserId = 12345,
	Name = "TestPlayer",
	Parent = Players,
}

local MockPerson = {
	getPlayer = function()
		return MockPlayer
	end,
}

-- Mock relic registry
local MockRelicRegistry = {
	["FireRelic"] = {
		configuration = {
			StatRanges = {
				Damage = { Min = 10, Max = 50 },
				Health = { Min = 5, Max = 25 },
			},
		},
		CheckCondition = function(self, unit)
			return unit.Element == "Fire" or unit.Element == nil
		end,
	},
	["WaterRelic"] = {
		configuration = {
			StatRanges = {
				Defense = { Min = 15, Max = 40 },
				Speed = { Min = 8, Max = 30 },
			},
		},
		CheckCondition = function(self, unit)
			return unit.Element == "Water"
		end,
	},
	["UniversalRelic"] = {
		configuration = {
			StatRanges = {
				Luck = { Min = 1, Max = 10 },
			},
		},
		-- No CheckCondition means it can be equipped to any unit
	},
}

-- Setup mock global registry
_G.Registry = {
	registry = {
		Items = MockRelicRegistry,
	},
}

describe("RelicService", function()
	local relicService

	beforeEach(function()
		-- Reset the service before each test
		relicService = require("@server/relic_service")

		-- Mock the inventory methods
		relicService._getPlayerInventory = function(self, player)
			return {
				Units = {
					["unit-1"] = {
						Name = "TestUnit",
						Element = "Fire",
						Relic = nil,
					},
					["unit-2"] = {
						Name = "WaterUnit",
						Element = "Water",
						Relic = nil,
					},
				},
				Items = {
					["relic-1"] = {
						Name = "FireRelic",
						Relic = true,
						Stats = {
							Damage = 1.3,
							Health = 1.15,
						},
					},
					["relic-2"] = {
						Name = "WaterRelic",
						Relic = true,
						Stats = {
							Defense = 1.25,
							Speed = 1.2,
						},
					},
					["item-1"] = {
						Name = "RegularItem",
						Relic = false,
					},
				},
			}
		end

		relicService._savePlayerInventory = function(self, player, inventory)
			-- Mock save operation
		end

		relicService._updateSlotbar = function(self, player)
			-- Mock UI update
		end
	end)

	describe("generateNewRelic", function()
		it("should generate a relic with random stats within configured ranges", function()
			local relicData = relicService:generateNewRelic(MockPerson, "FireRelic")

			expect(relicData).toBeDefined()
			expect(relicData.Relic).toBe(true)
			expect(relicData.Stats).toBeDefined()
			expect(relicData.Stats.Damage).toBeGreaterThanOrEqual(1.1) -- 1 + 10/100
			expect(relicData.Stats.Damage).toBeLessThanOrEqual(1.5) -- 1 + 50/100
			expect(relicData.Stats.Health).toBeGreaterThanOrEqual(1.05) -- 1 + 5/100
			expect(relicData.Stats.Health).toBeLessThanOrEqual(1.25) -- 1 + 25/100
		end)

		it("should return nil for non-existent relic types", function()
			local relicData = relicService:generateNewRelic(MockPerson, "NonExistentRelic")

			expect(relicData).toBeNil()
		end)

		it("should fire relicGenerated event", function()
			local eventFired = false
			local connection = relicService.relicGenerated:connect(function(person, relicName, relicData)
				if relicName == "FireRelic" then
					eventFired = true
				end
			end)

			relicService:generateNewRelic(MockPerson, "FireRelic")

			expect(eventFired).toBe(true)
			connection:disconnect()
		end)
	end)

	describe("checkRelicCondition", function()
		it("should return true when condition is met", function()
			local unit = { Element = "Fire" }
			local canEquip = relicService:checkRelicCondition(unit, "FireRelic")

			expect(canEquip).toBe(true)
		end)

		it("should return false when condition is not met", function()
			local unit = { Element = "Fire" }
			local canEquip = relicService:checkRelicCondition(unit, "WaterRelic")

			expect(canEquip).toBe(false)
		end)

		it("should return true for relics without conditions", function()
			local unit = { Element = "Fire" }
			local canEquip = relicService:checkRelicCondition(unit, "UniversalRelic")

			expect(canEquip).toBe(true)
		end)

		it("should return false for non-existent relics", function()
			local unit = { Element = "Fire" }
			local canEquip = relicService:checkRelicCondition(unit, "NonExistentRelic")

			expect(canEquip).toBe(false)
		end)
	end)

	describe("equipRelic", function()
		it("should successfully equip a compatible relic", function()
			local result = relicService:equipRelic(MockPerson, "unit-1", "relic-1")

			expect(result.Success).toBe(true)
			expect(result.Message).toBe("Relic equipped successfully")
		end)

		it("should fail to equip incompatible relic", function()
			local result = relicService:equipRelic(MockPerson, "unit-1", "relic-2")

			expect(result.Success).toBe(false)
			expect(result.Message).toBe("This relic cannot be equipped to this unit")
		end)

		it("should fail to equip to non-existent unit", function()
			local result = relicService:equipRelic(MockPerson, "non-existent-unit", "relic-1")

			expect(result.Success).toBe(false)
			expect(result.Message).toBe("Unit not found in inventory")
		end)

		it("should fail to equip non-existent relic", function()
			local result = relicService:equipRelic(MockPerson, "unit-1", "non-existent-relic")

			expect(result.Success).toBe(false)
			expect(result.Message).toBe("Relic not found in inventory")
		end)

		it("should fail to equip non-relic item", function()
			local result = relicService:equipRelic(MockPerson, "unit-1", "item-1")

			expect(result.Success).toBe(false)
			expect(result.Message).toBe("Item is not a relic")
		end)

		it("should fire relicEquipped event on success", function()
			local eventFired = false
			local connection = relicService.relicEquipped:connect(function(person, unitUUID, relicUUID)
				if unitUUID == "unit-1" and relicUUID == "relic-1" then
					eventFired = true
				end
			end)

			relicService:equipRelic(MockPerson, "unit-1", "relic-1")

			expect(eventFired).toBe(true)
			connection:disconnect()
		end)
	end)

	describe("unequipRelic", function()
		it("should successfully unequip a relic", function()
			-- First equip a relic
			relicService:equipRelic(MockPerson, "unit-1", "relic-1")

			-- Then unequip it
			local result = relicService:unequipRelic(MockPerson, "unit-1")

			expect(result.Success).toBe(true)
			expect(result.Message).toBe("Relic unequipped successfully")
		end)

		it("should fail to unequip from unit with no relic", function()
			local result = relicService:unequipRelic(MockPerson, "unit-1")

			expect(result.Success).toBe(false)
			expect(result.Message).toBe("Unit has no relic equipped")
		end)

		it("should fail to unequip from non-existent unit", function()
			local result = relicService:unequipRelic(MockPerson, "non-existent-unit")

			expect(result.Success).toBe(false)
			expect(result.Message).toBe("Unit not found in inventory")
		end)

		it("should fire relicUnequipped event on success", function()
			-- First equip a relic
			relicService:equipRelic(MockPerson, "unit-1", "relic-1")

			local eventFired = false
			local connection = relicService.relicUnequipped:connect(function(person, unitUUID, relicUUID)
				if unitUUID == "unit-1" and relicUUID == "relic-1" then
					eventFired = true
				end
			end)

			relicService:unequipRelic(MockPerson, "unit-1")

			expect(eventFired).toBe(true)
			connection:disconnect()
		end)
	end)

	describe("getPlayerRelics", function()
		it("should return all relics in player inventory", function()
			local relics = relicService:getPlayerRelics(MockPerson)

			expect(relics["relic-1"]).toBeDefined()
			expect(relics["relic-2"]).toBeDefined()
			expect(relics["item-1"]).toBeNil() -- Non-relic item should not be included
		end)
	end)

	describe("getEquippedRelic", function()
		it("should return equipped relic data", function()
			relicService:equipRelic(MockPerson, "unit-1", "relic-1")

			local equippedRelic = relicService:getEquippedRelic(MockPerson, "unit-1")

			expect(equippedRelic).toBeDefined()
			expect(equippedRelic.Name).toBe("FireRelic")
		end)

		it("should return nil for unit with no relic", function()
			local equippedRelic = relicService:getEquippedRelic(MockPerson, "unit-1")

			expect(equippedRelic).toBeNil()
		end)

		it("should return nil for non-existent unit", function()
			local equippedRelic = relicService:getEquippedRelic(MockPerson, "non-existent-unit")

			expect(equippedRelic).toBeNil()
		end)
	end)

	describe("getUnitRelicStats", function()
		it("should return relic stats for equipped relic", function()
			relicService:equipRelic(MockPerson, "unit-1", "relic-1")

			local stats = relicService:getUnitRelicStats(MockPerson, "unit-1")

			expect(stats.Damage).toBe(1.3)
			expect(stats.Health).toBe(1.15)
		end)

		it("should return empty table for unit with no relic", function()
			local stats = relicService:getUnitRelicStats(MockPerson, "unit-1")

			expect(next(stats)).toBeNil()
		end)
	end)

	describe("hasRelicEquipped", function()
		it("should return true for unit with equipped relic", function()
			relicService:equipRelic(MockPerson, "unit-1", "relic-1")

			local hasRelic = relicService:hasRelicEquipped(MockPerson, "unit-1")

			expect(hasRelic).toBe(true)
		end)

		it("should return false for unit with no relic", function()
			local hasRelic = relicService:hasRelicEquipped(MockPerson, "unit-1")

			expect(hasRelic).toBe(false)
		end)
	end)

	describe("getAvailableRelicTypes", function()
		it("should return list of available relic types", function()
			local relicTypes = relicService:getAvailableRelicTypes()

			expect(#relicTypes).toBeGreaterThan(0)
			expect(table.find(relicTypes, "FireRelic")).toBeDefined()
			expect(table.find(relicTypes, "WaterRelic")).toBeDefined()
			expect(table.find(relicTypes, "UniversalRelic")).toBeDefined()
		end)
	end)
end)
