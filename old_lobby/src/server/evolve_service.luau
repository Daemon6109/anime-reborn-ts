--------------------------------------------------------------------------------
-- evolve_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EvolveLibrary = require("@commonutils/EvolveLibrary")
local Network = require("@network/server")
local Person = require("@commonserver/person")
local UnitRegistry = require("@registry/Units")
local StatPotentialsRegistry = require("@registry/Buffs").StatPotentials

-- Network events
local UiCommunication = ReplicatedStorage.Events.UiCommunication

-- Stats to transfer from the old unit to the evolved one if TransferStats is true
local COPY_STATS = {
	"Level",
	"XP",
	"StatsPotential",
	"Traits",
	"Shiny",
	"Eliminations",
	"Relic",
}

-- Incremental chances for stat potential improvements
local INCREMENTAL_CHANCES = {
	[1] = {
		Chance = 20,
		Incremental = 0,
	},
	[2] = {
		Chance = 20,
		Incremental = 2,
	},
	[3] = {
		Chance = 45,
		Incremental = 1,
	},
	[4] = {
		Chance = 10,
		Incremental = 3,
	},
	[5] = {
		Chance = 5,
		Incremental = 4,
	},
}

--[=[
Service for handling unit evolution system.

@class EvolveService
]=]
local EvolveService = {
	version = version,
}

--[=[
Tracks player engagement with analytics

@within EvolveService

@param person Person -- The person to track
@param featureName string -- The feature being tracked

```lua
EvolveService.trackEngagement(person, "Evolve")
```
]=]
function EvolveService.trackEngagement(person: Person.Person, featureName: string): ()
	AnalyticsService:LogCustomEvent(person.player, "Engagement_" .. featureName)
end

--[=[
Gets a random incremental value for stat potential improvements

@within EvolveService

@return number -- The incremental value

@private
]=]
local function getRandomIncremental(): number
	local randomObject = Random.new()
	local totalWeight = 0

	-- Calculate total weight
	for _, data in pairs(INCREMENTAL_CHANCES) do
		totalWeight += data.Chance * 100000
	end

	local randomValue = randomObject:NextNumber(1, totalWeight)

	-- Select based on weight
	for _, data in pairs(INCREMENTAL_CHANCES) do
		totalWeight -= data.Chance * 100000
		if randomValue > totalWeight then
			return data.Incremental
		end
	end

	return 0
end

--[=[
Improves stat potentials for evolved unit

@within EvolveService

@param statsPotential { [string]: number } -- The current stats potential
@param statPotentialsRegistry any -- The stat potentials registry

@return { [string]: number } -- The improved stats potential

@private
]=]
local function improveStatsPotential(
	statsPotential: { [string]: number },
	statPotentialsRegistry: any
): { [string]: number }
	local improvedStats = table.clone(statsPotential)

	for statName, currentValue in pairs(improvedStats) do
		local incrementBy = getRandomIncremental()

		if incrementBy == 0 then
			continue
		end

		local currentSymbol = statPotentialsRegistry:GetSymbol(currentValue, statName)
		local symbolNumber = statPotentialsRegistry.OrderNums[currentSymbol]

		local highestNumber = #statPotentialsRegistry.Order
		local finalAmount = math.clamp(symbolNumber + incrementBy, 1, highestNumber)

		local newRank = statPotentialsRegistry.Order[finalAmount]
		local nextRank = statPotentialsRegistry.Order[finalAmount + 1]
		local newValue = statPotentialsRegistry[statName][newRank]

		if newRank ~= "SSS" then
			improvedStats[statName] = math.random(
				newValue * 1000,
				(statPotentialsRegistry[statName][nextRank] - 0.001) * 1000
			) / 1000
		else
			improvedStats[statName] = newValue
		end
	end

	return improvedStats
end

--[=[
Evolves a unit for a player

@within EvolveService

@param person Person -- The person evolving the unit
@param unitId string -- The ID of the unit to evolve
@param path number -- The evolution path to take

```lua
EvolveService.evolveUnit(person, "unit123", 1)
```
]=]
function EvolveService.evolveUnit(person: Person.Person, unitId: string, path: number): ()
	local dataCache = person.dataCache()
	local inventory = dataCache.Inventory
	local units = inventory.Units
	local items = inventory.Items

	local unitData = units[unitId]
	if not unitData then
		return
	end

	-- Check if unit can be evolved
	if not EvolveLibrary:CanEvolveUnit(person.player, unitId, path) then
		return
	end

	local unitConfig = UnitRegistry[unitData.UnitName]
	if not unitConfig or not unitConfig.configuration.EvolveData then
		return
	end

	local evolveData = unitConfig.configuration.EvolveData[path]
	if not evolveData then
		return
	end

	local evolvesInto = evolveData.EvolvesInto
	local requirements = evolveData.Requirements

	-- Prepare transfer data
	local transferData = {}
	if evolveData.TransferStats then
		for _, stat in ipairs(COPY_STATS) do
			transferData[stat] = unitData[stat]
		end
	end

	-- Remove the original unit
	if _G.serverServices and _G.serverServices.UnitManager then
		_G.serverServices.UnitManager:removeUnits(person.player, { unitId })
	else
		-- Fallback: remove from data cache
		local newCache = table.clone(dataCache)
		newCache.Inventory.Units[unitId] = nil
		person.dataCache(newCache)
	end

	-- Track engagement
	EvolveService.trackEngagement(person, "Evolve")

	-- Consume requirements
	for requirementName, requirementValue in pairs(requirements) do
		if type(requirementValue) ~= "table" then
			continue
		end

		for itemName, amount in pairs(requirementValue) do
			if requirementName == "Units" then
				-- Remove required units
				local totalFound = 0
				local unitsToRemove = {}

				for id, foundUnit in pairs(units) do
					if totalFound >= amount then
						break
					end

					if foundUnit.UnitName == itemName and not foundUnit.Locked then
						table.insert(unitsToRemove, id)
						totalFound += 1
					end
				end

				if _G.serverServices and _G.serverServices.UnitManager then
					_G.serverServices.UnitManager:removeUnits(person.player, unitsToRemove)
				else
					-- Fallback: remove from data cache
					local newCache = person.dataCache()
					for _, id in ipairs(unitsToRemove) do
						newCache.Inventory.Units[id] = nil
					end
					person.dataCache(newCache)
				end
			elseif requirementName == "Items" then
				-- Remove required items
				if _G.serverServices and _G.serverServices.ItemManager then
					_G.serverServices.ItemManager:GiveItems(person.player, { [itemName] = -amount })
				else
					-- Fallback: remove from data cache
					local newCache = person.dataCache()
					if newCache.Inventory.Items[itemName] then
						newCache.Inventory.Items[itemName].Count =
							math.max(0, newCache.Inventory.Items[itemName].Count - amount)
						if newCache.Inventory.Items[itemName].Count <= 0 then
							newCache.Inventory.Items[itemName] = nil
						end
					end
					person.dataCache(newCache)
				end
			end
		end
	end

	-- Improve stat potentials if transferring stats
	if transferData.StatsPotential then
		transferData.StatsPotential = improveStatsPotential(transferData.StatsPotential, StatPotentialsRegistry)
	end

	-- Give the evolved unit
	local evolvedUnitId: string?
	if _G.serverServices and _G.serverServices.UnitManager then
		local idList = _G.serverServices.UnitManager:giveUnit(person.player, evolvesInto, 1, transferData)
		evolvedUnitId = idList and idList[1]
	else
		-- Fallback: add to data cache
		evolvedUnitId = HttpService:GenerateGUID(false)
		local newCache = person.dataCache()
		newCache.Inventory.Units[evolvedUnitId] = table.clone(transferData)
		newCache.Inventory.Units[evolvedUnitId].UnitName = evolvesInto
		person.dataCache(newCache)
	end

	-- Trigger evolution success event
	if UiCommunication and evolvedUnitId then
		UiCommunication:FireClient(person.player, "Evolve/OnEvolveSuccess", evolvedUnitId)
	end
end

--[=[
Initializes the EvolveService

@within EvolveService
]=]
function EvolveService.start(): ()
	-- Set up network handlers
	Network.registerHandler("Evolve/EvolveUnit", function(player: Player, unitId: string, path: number)
		local person = Person.getForPlayer(player)
		if person then
			EvolveService.evolveUnit(person, unitId, path)
		end
	end)

	print("EvolveService started")
end

return EvolveService
