--!strict
--------------------------------------------------------------------------------
-- unit_manager
-- Manages unit operations, upgrades, and statistics
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local _Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _RunService = game:GetService("RunService")

-- Load Units registry - fallback to basic registry if not available
local Units = {}
local success, result = pcall(function()
	return require(ReplicatedStorage.Registry.Units)
end)

if success then
	Units = result
else
	-- Fallback unit registry for testing
	Units = {
		["basic_swordsman"] = {
			id = "basic_swordsman",
			name = "Basic Swordsman",
			rarity = "Common",
			cost = 100,
			damage = 50,
			range = 1,
			attackSpeed = 1.0,
			series = "Starter",
		},
	}
end

-- Create signals for unit events
local unitUpgradedEvent = Shingo.new() :: any
local unitEvolvedEvent = Shingo.new() :: any
local unitSummonedEvent = Shingo.new() :: any

export type UnitInstance = {
	id: string,
	unitId: string,
	level: number,
	experience: number,
	power: number,
	shiny: boolean?,
	placement: {
		x: number?,
		y: number?,
		mapId: string?,
	}?,
}

--[=[
Service for managing player units

@class UnitManager
]=]
local UnitManager = {
	version = version,

	-- Registry for unit configurations
	registry = Units,

	-- Events
	unitUpgraded = unitUpgradedEvent,
	unitEvolved = unitEvolvedEvent,
	unitSummoned = unitSummonedEvent,
}

--[=[
Gets all units for a player

@within UnitManager

@param person Person -- The person to get units for

@return { UnitInstance } -- Array of unit instances

```lua
local units = UnitManager.getPlayerUnits(person)
```
]=]
function UnitManager.getPlayerUnits(person: Person.Person): { UnitInstance }
	local cache = person.dataCache()
	return cache.Inventory.Units or {}
end

--[=[
Adds a new unit to a player's collection

@within UnitManager

@param person Person -- The person to add the unit to
@param unitId string -- The unit type ID
@param level number? -- Starting level (defaults to 1)
@param additionalData table? -- Additional data like { Shiny = true }

@return UnitInstance? -- The created unit instance

```lua
local newUnit = UnitManager.addUnit(person, "basic_swordsman", 1)
```
]=]
function UnitManager.addUnit(
	person: Person.Person,
	unitId: string,
	level: number?,
	additionalData: { [string]: any }?
): UnitInstance?
	local unitData = Units[unitId]
	if not unitData then
		warn(`UnitManager: Invalid unit ID: {unitId}`)
		return nil
	end

	local startLevel = level or 1
	local newUnit: UnitInstance = {
		id = HttpService:GenerateGUID(false),
		unitId = unitId,
		level = startLevel,
		experience = 0,
		power = UnitManager.calculateUnitPower(unitId, startLevel),
		shiny = if additionalData then additionalData.Shiny else nil,
	}

	person.dataCache(function(dataCache)
		table.insert(dataCache.Inventory.Units, newUnit)
		return dataCache
	end)

	-- Fire events
	unitSummonedEvent:fire(person.player, unitId)

	return newUnit
end

--[=[
Removes a unit from a player's collection

@within UnitManager

@param person Person -- The person to remove the unit from
@param unitInstanceId string -- The unique unit instance ID

@return boolean -- Whether the unit was successfully removed

```lua
local removed = UnitManager.removeUnit(person, "unit-instance-id")
```
]=]
function UnitManager.removeUnit(person: Person.Person, unitInstanceId: string): boolean
	local removed = false

	person.dataCache(function(dataCache)
		local units = dataCache.Inventory.Units
		for i, unit in ipairs(units) do
			if unit.id == unitInstanceId then
				table.remove(units, i)
				removed = true
				break
			end
		end
		return dataCache
	end)

	return removed
end

--[=[
Upgrades a unit to the next level

@within UnitManager

@param person Person -- The person who owns the unit
@param unitInstanceId string -- The unique unit instance ID

@return boolean -- Whether the upgrade was successful

```lua
local upgraded = UnitManager.upgradeUnit(person, "unit-instance-id")
```
]=]
function UnitManager.upgradeUnit(person: Person.Person, unitInstanceId: string): boolean
	local upgraded = false
	local newLevel = 0
	local unitId = ""

	person.dataCache(function(dataCache)
		local units = dataCache.Inventory.Units
		
		for _, unit in ipairs(units) do
			if unit.id == unitInstanceId then
				-- Check upgrade cost (simplified)
				local upgradeCost = unit.level * 100
				if dataCache.Currencies.Gold >= upgradeCost then
					-- Apply cost
					dataCache.Currencies.Gold = dataCache.Currencies.Gold - upgradeCost

					-- Upgrade unit
					unit.level += 1
					unit.power = UnitManager.calculateUnitPower(unit.unitId, unit.level)

					upgraded = true
					newLevel = unit.level
					unitId = unit.unitId
				end
				break
			end
		end

		return dataCache
	end)

	if upgraded then
		unitUpgradedEvent:fire(person.player, unitId, newLevel)
	end

	return upgraded
end

--[=[
Evolves a unit to a new form (simplified version without EvolveLibrary)

@within UnitManager

@param person Person -- The person who owns the unit
@param unitInstanceId string -- The unique unit instance ID
@param targetUnitId string -- The target evolution unit ID

@return boolean -- Whether the evolution was successful

```lua
local evolved = UnitManager.evolveUnit(person, "unit-instance-id", "knight_swordsman")
```
]=]
function UnitManager.evolveUnit(person: Person.Person, unitInstanceId: string, targetUnitId: string): boolean
	local evolved = false
	local fromUnitId = ""

	-- Check if target unit exists
	if not Units[targetUnitId] then
		warn(`UnitManager: Invalid target evolution unit ID: {targetUnitId}`)
		return false
	end

	person.dataCache(function(dataCache)
		local units = dataCache.Inventory.Units
		
		for _, unit in ipairs(units) do
			if unit.id == unitInstanceId then
				-- Simple evolution check - require minimum level and some cost
				local evolutionCost = 1000
				if unit.level >= 10 and dataCache.Currencies.Gold >= evolutionCost then
					fromUnitId = unit.unitId
					
					-- Apply evolution cost
					dataCache.Currencies.Gold = dataCache.Currencies.Gold - evolutionCost
					
					-- Update unit
					unit.unitId = targetUnitId
					unit.power = UnitManager.calculateUnitPower(unit.unitId, unit.level)
					
					evolved = true
				end
				break
			end
		end

		return dataCache
	end)

	if evolved then
		unitEvolvedEvent:fire(person.player, fromUnitId, targetUnitId)
	end

	return evolved
end

--[=[
Calculates the power rating for a unit

@within UnitManager

@param unitId string -- The unit type ID
@param level number -- The unit's level

@return number -- The calculated power

```lua
local power = UnitManager.calculateUnitPower("basic_swordsman", 10)
```
]=]
function UnitManager.calculateUnitPower(unitId: string, level: number): number
	local unitData = Units[unitId]
	if not unitData then
		return 0
	end

	-- Base power calculation: (base damage + base cost) * level scaling
	local basePower = unitData.damage + (unitData.cost / 10)
	local levelMultiplier = 1 + (level - 1) * 0.1

	return math.floor(basePower * levelMultiplier)
end

--[=[
Gets a specific unit instance

@within UnitManager

@param person Person -- The person who owns the unit
@param unitInstanceId string -- The unique unit instance ID

@return UnitInstance? -- The unit instance if found

```lua
local unit = UnitManager.getUnit(person, "unit-instance-id")
```
]=]
function UnitManager.getUnit(person: Person.Person, unitInstanceId: string): UnitInstance?
	local units = UnitManager.getPlayerUnits(person)

	for _, unit in ipairs(units) do
		if unit.id == unitInstanceId then
			return unit
		end
	end

	return nil
end

--[=[
Places a unit on a map

@within UnitManager

@param person Person -- The person who owns the unit
@param unitInstanceId string -- The unique unit instance ID
@param x number -- X coordinate
@param y number -- Y coordinate
@param mapId string -- Map identifier

@return boolean -- Whether the placement was successful

```lua
local placed = UnitManager.placeUnit(person, "unit-instance-id", 5, 3, "grasslands")
```
]=]
function UnitManager.placeUnit(
	person: Person.Person,
	unitInstanceId: string,
	x: number,
	y: number,
	mapId: string
): boolean
	local placed = false

	person.dataCache(function(dataCache)
		local units = dataCache.Inventory.Units
		
		for _, unit in ipairs(units) do
			if unit.id == unitInstanceId then
				unit.placement = {
					x = x,
					y = y,
					mapId = mapId,
				}
				placed = true
				break
			end
		end

		return dataCache
	end)

	return placed
end

--[=[
Initializes the unit manager service

@within UnitManager

```lua
UnitManager.init()
```
]=]
function UnitManager.init(): ()
	-- Network event handlers can be added here when needed
	print("UnitManager initialized with version", version.major, version.minor, version.patch)
end

return UnitManager
