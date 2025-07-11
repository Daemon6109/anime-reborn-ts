--------------------------------------------------------------------------------
-- alchemy_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require("@network/server")
local Person = require("@commonserver/person")

local loadModules = require("@commonutils/loadModules")

local ItemRegistry = loadModules:fromChildren(ReplicatedStorage.Registry.Items)
local PotionRegistry = loadModules:fromChildren(ReplicatedStorage.Registry.Potions)

-- Network events
local UiCommunication = ReplicatedStorage.Events.UiCommunication

--[=[
Service for handling alchemy and potion brewing.

@class AlchemyService
]=]
local AlchemyService = {
	version = version,
}

--[=[
Tracks player engagement with analytics

@within AlchemyService

@param person Person -- The person to track
@param featureName string -- The feature being tracked

```lua
AlchemyService.trackEngagement(person, "Alchemy")
```
]=]
function AlchemyService.trackEngagement(person: Person.Person, featureName: string): ()
	AnalyticsService:LogCustomEvent(person.player, "Engagement_" .. featureName)
end

--[=[
Checks if a player has enough ingredients for a potion recipe

@within AlchemyService

@param person Person -- The person to check ingredients for
@param recipe { { Name: string, Cost: number } } -- The recipe requirements
@param redstoneCost number -- The redstone cost

@return boolean -- Whether the player has enough ingredients

@private
]=]
local function hasEnoughIngredients(
	person: Person.Person,
	recipe: { { Name: string, Cost: number } },
	redstoneCost: number
): boolean
	local dataCache = person.dataCache()
	local inventory = dataCache.Inventory.Items

	local redstoneData = inventory["Redstone"]

	-- Check redstone cost
	local redstoneCount = if redstoneData then redstoneData.Count else 0
	if redstoneCount < redstoneCost then
		return false
	end

	-- Check recipe ingredients
	for _, ingredient in ipairs(recipe) do
		local itemCount = inventory[ingredient.Name] or 0
		if itemCount < ingredient.Cost then
			return false
		end
	end

	return true
end

--[=[
Consumes ingredients and gives the brewed potion to the player

@within AlchemyService

@param person Person -- The person to give items to
@param potionName string -- The name of the potion to brew
@param recipe { { Name: string, Cost: number } } -- The recipe requirements
@param redstoneCost number -- The redstone cost

@private
]=]
local function consumeIngredientsAndGivePotion(
	person: Person.Person,
	potionName: string,
	recipe: { { Name: string, Cost: number } },
	redstoneCost: number
): ()
	person.dataCache(function(newCache)
		local inventory = newCache.Inventory.Items

		local redstoneData = inventory["Redstone"]
		local redstoneCount = if redstoneData then redstoneData.Count else 0

		-- Consume redstone
		inventory.Redstone.Count = redstoneCount - redstoneCost

		-- Consume recipe ingredients
		for _, ingredient in ipairs(recipe) do
			inventory[ingredient.Name].Cost = (inventory[ingredient.Name].Cost or 0) - ingredient.Cost
		end

		-- Give the brewed potion
		inventory[potionName].Count = (inventory[potionName].Count or 0) + 1

		-- Update data cache
		return newCache
	end)
end

--[=[
Brews a potion for a player

@within AlchemyService

@param person Person -- The person brewing the potion
@param potionName string -- The name of the potion to brew

```lua
AlchemyService.brewPotion(person, "HealthPotion")
```
]=]
function AlchemyService.brewPotion(person: Person.Person, potionName: string): ()
	local potionData = PotionRegistry[potionName]
	if not potionData then
		warn(`Potion "{potionName}" not found in registry`)
		return
	end

	local itemData = ItemRegistry[potionName]
	if not itemData then
		warn(`Item data for potion "{potionName}" not found in registry`)
		return
	end

	local potionConfig = potionData.configuration
	if not potionConfig then
		warn(`Configuration not found for potion "{potionName}"`)
		return
	end

	-- Check if player has enough ingredients
	if not hasEnoughIngredients(person, potionConfig.Recipe, potionConfig.RedstoneCost) then
		-- Not enough ingredients, could send a notification here
		return
	end

	-- Consume ingredients and give potion
	consumeIngredientsAndGivePotion(person, potionName, potionConfig.Recipe, potionConfig.RedstoneCost)

	-- Track engagement
	AlchemyService.trackEngagement(person, "Alchemy")

	-- Notify client
	if UiCommunication then
		UiCommunication:FireClient(person.player, "Alchemy/PotionBrewed", potionName)
	end
end

--[=[
Initializes the AlchemyService

@within AlchemyService
]=]
function AlchemyService.start(): ()
	-- Set up network handlers
	Network.registerHandler("Alchemy/Brew", function(player: Player, potionName: string): ()
		local personFuture = Person.getForPlayer(player)
		local person = personFuture:Expect("Person not found for player " .. player.Name)
		if person then
			AlchemyService.brewPotion(person, potionName)
		end
	end)

	print("AlchemyService started")
end

return AlchemyService
