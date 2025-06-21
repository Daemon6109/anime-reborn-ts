--------------------------------------------------------------------------------
-- EvolveLibrary
-- Handles unit evolution logic and calculations
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Units = require("@constants/Units")

export type EvolutionPath = {
	fromUnitId: string,
	toUnitId: string,
	requirements: {
		level: number?,
		materials: { [string]: number }?,
		currency: { [string]: number }?,
	},
}

export type EvolutionResult = {
	success: boolean,
	error: string?,
	newUnitId: string?,
	costsApplied: { [string]: number }?,
}

--[=[
Library for handling unit evolution mechanics

@class EvolveLibrary
]=]
local EvolveLibrary = {
	version = version,
}

-- Evolution paths configuration
local evolutionPaths: { [string]: EvolutionPath } = {
	["basic_swordsman_to_knight"] = {
		fromUnitId = "basic_swordsman",
		toUnitId = "knight_swordsman",
		requirements = {
			level = 10,
			materials = {
				upgrade_stone = 5,
				evolution_crystal = 1,
			},
			currency = {
				coins = 1000,
			},
		},
	},

	["basic_archer_to_ranger"] = {
		fromUnitId = "basic_archer",
		toUnitId = "forest_ranger",
		requirements = {
			level = 10,
			materials = {
				upgrade_stone = 5,
				evolution_crystal = 1,
			},
			currency = {
				coins = 1000,
			},
		},
	},

	["fire_mage_to_archmage"] = {
		fromUnitId = "fire_mage",
		toUnitId = "fire_archmage",
		requirements = {
			level = 25,
			materials = {
				upgrade_stone = 15,
				evolution_crystal = 3,
				fire_essence = 2,
			},
			currency = {
				coins = 5000,
				gems = 10,
			},
		},
	},
}

--[=[
Gets all available evolution paths for a unit

@within EvolveLibrary

@param unitId string -- The unit ID to check evolutions for

@return { EvolutionPath } -- Array of available evolution paths

```lua
local paths = EvolveLibrary.getEvolutionPaths("basic_swordsman")
```
]=]
function EvolveLibrary.getEvolutionPaths(unitId: string): { EvolutionPath }
	local paths = {}

	for _, path in pairs(evolutionPaths) do
		if path.fromUnitId == unitId then
			table.insert(paths, path)
		end
	end

	return paths
end

--[=[
Checks if a unit can evolve based on requirements

@within EvolveLibrary

@param unitData any -- The unit data including level, etc.
@param playerInventory { [string]: number } -- Player's inventory
@param playerCurrency { [string]: number } -- Player's currency
@param targetUnitId string -- The target evolution unit ID

@return boolean -- Whether evolution is possible

```lua
local canEvolve = EvolveLibrary.canEvolve(unitData, inventory, currency, "knight_swordsman")
```
]=]
function EvolveLibrary.canEvolve(
	unitData: any,
	playerInventory: { [string]: number },
	playerCurrency: { [string]: number },
	targetUnitId: string
): boolean
	local path = nil

	-- Find the evolution path
	for _, evolutionPath in pairs(evolutionPaths) do
		if evolutionPath.fromUnitId == unitData.id and evolutionPath.toUnitId == targetUnitId then
			path = evolutionPath
			break
		end
	end

	if not path then
		return false
	end

	-- Check level requirement
	if path.requirements.level and unitData.level < path.requirements.level then
		return false
	end

	-- Check material requirements
	if path.requirements.materials then
		for materialId, requiredAmount in pairs(path.requirements.materials) do
			local playerAmount = playerInventory[materialId] or 0
			if playerAmount < requiredAmount then
				return false
			end
		end
	end

	-- Check currency requirements
	if path.requirements.currency then
		for currencyType, requiredAmount in pairs(path.requirements.currency) do
			local playerAmount = playerCurrency[currencyType] or 0
			if playerAmount < requiredAmount then
				return false
			end
		end
	end

	return true
end

--[=[
Evolves a unit and applies the costs

@within EvolveLibrary

@param unitData any -- The unit data to evolve
@param playerInventory { [string]: number } -- Player's inventory (will be modified)
@param playerCurrency { [string]: number } -- Player's currency (will be modified)
@param targetUnitId string -- The target evolution unit ID

@return EvolutionResult -- The result of the evolution attempt

```lua
local result = EvolveLibrary.evolveUnit(unitData, inventory, currency, "knight_swordsman")
```
]=]
function EvolveLibrary.evolveUnit(
	unitData: any,
	playerInventory: { [string]: number },
	playerCurrency: { [string]: number },
	targetUnitId: string
): EvolutionResult
	-- Check if evolution is possible
	if not EvolveLibrary.canEvolve(unitData, playerInventory, playerCurrency, targetUnitId) then
		return {
			success = false,
			error = "Evolution requirements not met",
		}
	end

	-- Find the evolution path
	local path = nil
	for _, evolutionPath in pairs(evolutionPaths) do
		if evolutionPath.fromUnitId == unitData.id and evolutionPath.toUnitId == targetUnitId then
			path = evolutionPath
			break
		end
	end

	if not path then
		return {
			success = false,
			error = "Invalid evolution path",
		}
	end

	local costsApplied = {}

	-- Apply material costs
	if path.requirements.materials then
		for materialId, requiredAmount in pairs(path.requirements.materials) do
			playerInventory[materialId] = playerInventory[materialId] - requiredAmount
			costsApplied[materialId] = requiredAmount
		end
	end

	-- Apply currency costs
	if path.requirements.currency then
		for currencyType, requiredAmount in pairs(path.requirements.currency) do
			playerCurrency[currencyType] = playerCurrency[currencyType] - requiredAmount
			costsApplied[currencyType] = requiredAmount
		end
	end

	return {
		success = true,
		newUnitId = targetUnitId,
		costsApplied = costsApplied,
	}
end

--[=[
Gets the evolution requirements for a specific path

@within EvolveLibrary

@param fromUnitId string -- The source unit ID
@param toUnitId string -- The target unit ID

@return EvolutionPath? -- The evolution path if it exists

```lua
local requirements = EvolveLibrary.getEvolutionRequirements("basic_swordsman", "knight_swordsman")
```
]=]
function EvolveLibrary.getEvolutionRequirements(fromUnitId: string, toUnitId: string): EvolutionPath?
	for _, path in pairs(evolutionPaths) do
		if path.fromUnitId == fromUnitId and path.toUnitId == toUnitId then
			return path
		end
	end

	return nil
end

return EvolveLibrary
