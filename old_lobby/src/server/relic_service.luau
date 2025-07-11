--------------------------------------------------------------------------------
-- relic_service
-- Manages player relic equipment, stats, and conditions
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local Players = game:GetService("Players")

-- Type definitions
export type RelicStats = {
	[string]: number,
}

export type RelicData = {
	Relic: boolean,
	Stats: RelicStats,
}

export type RelicConfig = {
	configuration: {
		StatRanges: {
			[string]: {
				Min: number,
				Max: number,
			},
		},
	},
	CheckCondition: ((any, any) -> boolean)?,
}

export type EquipResult = {
	Success: boolean,
	Message: string,
}

--- @class RelicService
--- Service for managing player relics and equipment
---
--- ```luau
--- local RelicService = require("relic_service")
---
--- -- Generate new relic stats
--- local relicData = RelicService:generateNewRelic(person, "FireRelic")
---
--- -- Equip relic to unit
--- local result = RelicService:equipRelic(person, "unit-uuid", "relic-uuid")
--- ```
local RelicService = {}
RelicService.__index = RelicService

-- Events
local relicEquipped = Shingo.createSignal() :: Shingo.Signal<Person.Person, string, string>
local relicUnequipped = Shingo.createSignal() :: Shingo.Signal<Person.Person, string, string>
local relicGenerated = Shingo.createSignal() :: Shingo.Signal<Person.Person, string, RelicData>

-- Internal state
local relicRegistry = {}

--- Initialize the relic service
--- @return RelicService
function RelicService.init(): typeof(RelicService)
	local self = setmetatable({}, RelicService)

	-- Load relic registry
	if _G.Registry and _G.Registry.registry and _G.Registry.registry.Items then
		relicRegistry = _G.Registry.registry.Items
	end

	-- Setup network handlers
	self:_setupNetworking()

	return self
end

--- Generate new relic data with random stats
--- @param person Person.Person -- The player generating the relic
--- @param relicName string -- Name of the relic type
--- @return RelicData? -- Generated relic data or nil if invalid
--- @error "Relic not found" -- If relic type doesn't exist
function RelicService:generateNewRelic(person: Person.Person, relicName: string): RelicData?
	local relicConfig = relicRegistry[relicName]

	if not relicConfig then
		warn(`[RelicService] Relic named {relicName} doesn't exist`)
		return nil
	end

	if not relicConfig.configuration or not relicConfig.configuration.StatRanges then
		warn(`[RelicService] Relic {relicName} has no stat ranges configured`)
		return nil
	end

	local newRelicData: RelicData = {
		Relic = true,
		Stats = {},
	}

	-- Generate random stats based on configured ranges
	for statName, range in relicConfig.configuration.StatRanges do
		local randomValue = math.random(range.Min, range.Max)
		newRelicData.Stats[statName] = 1 + (randomValue / 100)
	end

	relicGenerated:fire(person, relicName, newRelicData)
	return newRelicData
end

--- Check if a relic can be equipped to a unit
--- @param unit table -- The unit data
--- @param relicName string -- Name of the relic type
--- @return boolean -- True if relic can be equipped
function RelicService:checkRelicCondition(unit: { [string]: any }, relicName: string): boolean
	local relicConfig = relicRegistry[relicName]

	if not relicConfig then
		return false
	end

	if relicConfig.CheckCondition then
		return relicConfig:CheckCondition(unit)
	end

	return true
end

--- Equip a relic to a unit
--- @param person Person.Person -- The player equipping the relic
--- @param unitUUID string -- UUID of the unit to equip to
--- @param relicUUID string -- UUID of the relic to equip
--- @return EquipResult -- Result of the equip attempt
--- @error "Unit not found" -- If unit doesn't exist in inventory
--- @error "Relic not found" -- If relic doesn't exist in inventory
--- @error "Condition not met" -- If relic cannot be equipped to this unit
function RelicService:equipRelic(person: Person.Person, unitUUID: string, relicUUID: string): EquipResult
	local player = person:getPlayer()

	-- In a real implementation, this would interact with the data store
	-- For now, we'll simulate the logic

	local inventory = self:_getPlayerInventory(player)
	local foundUnit = inventory.Units and inventory.Units[unitUUID]
	local foundRelic = inventory.Items and inventory.Items[relicUUID]

	if not foundUnit then
		return {
			Success = false,
			Message = "Unit not found in inventory",
		}
	end

	if not foundRelic then
		return {
			Success = false,
			Message = "Relic not found in inventory",
		}
	end

	if not foundRelic.Relic then
		return {
			Success = false,
			Message = "Item is not a relic",
		}
	end

	-- Check if relic can be equipped to this unit
	local canEquip = self:checkRelicCondition(foundUnit, foundRelic.Name or "")

	if not canEquip then
		return {
			Success = false,
			Message = "This relic cannot be equipped to this unit",
		}
	end

	-- Unequip previous relic if exists
	if foundUnit.Relic then
		self:unequipRelic(person, unitUUID)
	end

	-- Equip the new relic
	foundUnit.Relic = relicUUID
	self:_savePlayerInventory(player, inventory)

	-- Update UI/slotbar
	self:_updateSlotbar(player)

	relicEquipped:fire(person, unitUUID, relicUUID)

	return {
		Success = true,
		Message = "Relic equipped successfully",
	}
end

--- Unequip a relic from a unit
--- @param person Person.Person -- The player unequipping the relic
--- @param unitUUID string -- UUID of the unit to unequip from
--- @return EquipResult -- Result of the unequip attempt
function RelicService:unequipRelic(person: Person.Person, unitUUID: string): EquipResult
	local player = person:getPlayer()
	local inventory = self:_getPlayerInventory(player)
	local foundUnit = inventory.Units and inventory.Units[unitUUID]

	if not foundUnit then
		return {
			Success = false,
			Message = "Unit not found in inventory",
		}
	end

	if not foundUnit.Relic then
		return {
			Success = false,
			Message = "Unit has no relic equipped",
		}
	end

	local relicUUID = foundUnit.Relic
	foundUnit.Relic = nil
	self:_savePlayerInventory(player, inventory)

	-- Update UI/slotbar
	self:_updateSlotbar(player)

	relicUnequipped:fire(person, unitUUID, relicUUID)

	return {
		Success = true,
		Message = "Relic unequipped successfully",
	}
end

--- Get all relics in player's inventory
--- @param person Person.Person -- The player
--- @return { [string]: RelicData } -- Dictionary of relic UUIDs to relic data
function RelicService:getPlayerRelics(person: Person.Person): { [string]: RelicData }
	local player = person:getPlayer()
	local inventory = self:_getPlayerInventory(player)
	local relics = {}

	if inventory.Items then
		for uuid, item in inventory.Items do
			if item.Relic then
				relics[uuid] = item
			end
		end
	end

	return relics
end

--- Get equipped relic for a unit
--- @param person Person.Person -- The player
--- @param unitUUID string -- UUID of the unit
--- @return RelicData? -- Equipped relic data or nil if none equipped
function RelicService:getEquippedRelic(person: Person.Person, unitUUID: string): RelicData?
	local player = person:getPlayer()
	local inventory = self:_getPlayerInventory(player)
	local foundUnit = inventory.Units and inventory.Units[unitUUID]

	if not foundUnit or not foundUnit.Relic then
		return nil
	end

	local relicUUID = foundUnit.Relic
	return inventory.Items and inventory.Items[relicUUID]
end

--- Get relic stats for a unit (combines base unit stats with relic bonuses)
--- @param person Person.Person -- The player
--- @param unitUUID string -- UUID of the unit
--- @return RelicStats -- Combined stats
function RelicService:getUnitRelicStats(person: Person.Person, unitUUID: string): RelicStats
	local equippedRelic = self:getEquippedRelic(person, unitUUID)

	if not equippedRelic or not equippedRelic.Stats then
		return {}
	end

	return table.clone(equippedRelic.Stats)
end

--- Check if a unit has a relic equipped
--- @param person Person.Person -- The player
--- @param unitUUID string -- UUID of the unit
--- @return boolean -- True if unit has a relic equipped
function RelicService:hasRelicEquipped(person: Person.Person, unitUUID: string): boolean
	return self:getEquippedRelic(person, unitUUID) ~= nil
end

--- Get relic configuration
--- @param relicName string -- Name of the relic type
--- @return RelicConfig? -- Relic configuration or nil if not found
function RelicService:getRelicConfig(relicName: string): RelicConfig?
	return relicRegistry[relicName]
end

--- Get all available relic types
--- @return { string } -- Array of relic type names
function RelicService:getAvailableRelicTypes(): { string }
	local relicTypes = {}

	for relicName, config in relicRegistry do
		if config.configuration and config.configuration.StatRanges then
			table.insert(relicTypes, relicName)
		end
	end

	return relicTypes
end

-- Private methods

function RelicService:_setupNetworking(): ()
	Network.server.relics.equipRelic:connect(function(person: Person.Person, unitUUID: string, relicUUID: string)
		return self:equipRelic(person, unitUUID, relicUUID)
	end)

	Network.server.relics.unequipRelic:connect(function(person: Person.Person, unitUUID: string)
		return self:unequipRelic(person, unitUUID)
	end)

	Network.server.relics.getPlayerRelics:connect(function(person: Person.Person)
		return self:getPlayerRelics(person)
	end)

	Network.server.relics.generateNewRelic:connect(function(person: Person.Person, relicName: string)
		return self:generateNewRelic(person, relicName)
	end)
end

function RelicService:_getPlayerInventory(player: Player): { [string]: any }
	-- In a real implementation, this would load from DataStore
	-- For now, return mock data
	return {
		Units = {},
		Items = {},
	}
end

function RelicService:_savePlayerInventory(player: Player, inventory: { [string]: any }): ()
	-- In a real implementation, this would save to DataStore
end

function RelicService:_updateSlotbar(player: Player): ()
	-- In a real implementation, this would update the player's UI
	-- This might call UnitManager:UpdateSlotbar(player)
end

-- Events
RelicService.relicEquipped = relicEquipped
RelicService.relicUnequipped = relicUnequipped
RelicService.relicGenerated = relicGenerated

-- Version
RelicService.version = version

return RelicService.init()
