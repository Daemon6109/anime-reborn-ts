--------------------------------------------------------------------------------
-- CraftingLibrary
-- Handles item crafting logic and recipes
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Items = require("@constants/Items")

export type CraftingRecipe = {
	id: string,
	name: string,
	description: string,
	resultItem: string,
	resultQuantity: number,
	ingredients: { [string]: number },
	craftingTime: number?,
	unlockLevel: number?,
	category: string,
}

export type CraftingResult = {
	success: boolean,
	error: string?,
	resultItem: string?,
	resultQuantity: number?,
	costsApplied: { [string]: number }?,
}

--[=[
Library for handling item crafting mechanics

@class CraftingLibrary
]=]
local CraftingLibrary = {
	version = version,
}

-- Crafting recipes configuration
local recipes: { [string]: CraftingRecipe } = {
	-- Basic potions
	["craft_health_potion"] = {
		id = "craft_health_potion",
		name = "Health Potion",
		description = "Craft a basic health potion",
		resultItem = "health_potion",
		resultQuantity = 1,
		ingredients = {
			healing_herbs = 3,
			water_essence = 1,
		},
		craftingTime = 10,
		unlockLevel = 5,
		category = "Potions",
	},

	["craft_mana_potion"] = {
		id = "craft_mana_potion",
		name = "Mana Potion",
		description = "Craft a basic mana potion",
		resultItem = "mana_potion",
		resultQuantity = 1,
		ingredients = {
			mana_crystals = 2,
			spirit_water = 1,
		},
		craftingTime = 12,
		unlockLevel = 7,
		category = "Potions",
	},

	-- Advanced potions
	["craft_strength_potion"] = {
		id = "craft_strength_potion",
		name = "Strength Potion",
		description = "Craft a potion that increases damage",
		resultItem = "strength_potion",
		resultQuantity = 1,
		ingredients = {
			power_herbs = 5,
			beast_essence = 2,
			health_potion = 1,
		},
		craftingTime = 30,
		unlockLevel = 15,
		category = "Buff Potions",
	},

	["craft_speed_potion"] = {
		id = "craft_speed_potion",
		name = "Speed Potion",
		description = "Craft a potion that increases attack speed",
		resultItem = "speed_potion",
		resultQuantity = 1,
		ingredients = {
			swift_leaves = 4,
			wind_essence = 2,
			mana_potion = 1,
		},
		craftingTime = 25,
		unlockLevel = 12,
		category = "Buff Potions",
	},

	-- Equipment crafting
	["craft_upgrade_stone"] = {
		id = "craft_upgrade_stone",
		name = "Upgrade Stone",
		description = "Craft stones used for unit upgrades",
		resultItem = "upgrade_stone",
		resultQuantity = 3,
		ingredients = {
			raw_stones = 10,
			earth_essence = 2,
		},
		craftingTime = 60,
		unlockLevel = 10,
		category = "Materials",
	},

	["craft_evolution_crystal"] = {
		id = "craft_evolution_crystal",
		name = "Evolution Crystal",
		description = "Craft crystals used for unit evolution",
		resultItem = "evolution_crystal",
		resultQuantity = 1,
		ingredients = {
			upgrade_stone = 5,
			magic_essence = 3,
			rare_gems = 2,
		},
		craftingTime = 300,
		unlockLevel = 25,
		category = "Materials",
	},

	-- Special items
	["craft_basic_crate"] = {
		id = "craft_basic_crate",
		name = "Basic Crate",
		description = "Craft a crate containing random units",
		resultItem = "basic_crate",
		resultQuantity = 1,
		ingredients = {
			wooden_planks = 8,
			iron_nails = 4,
			unit_fragments = 10,
		},
		craftingTime = 120,
		unlockLevel = 20,
		category = "Crates",
	},
}

--[=[
Gets all available crafting recipes

@within CraftingLibrary

@return { CraftingRecipe } -- Array of all recipes

```lua
local allRecipes = CraftingLibrary.getAllRecipes()
```
]=]
function CraftingLibrary.getAllRecipes(): { CraftingRecipe }
	local recipeList = {}
	for _, recipe in pairs(recipes) do
		table.insert(recipeList, recipe)
	end
	return recipeList
end

--[=[
Gets recipes by category

@within CraftingLibrary

@param category string -- The category to filter by

@return { CraftingRecipe } -- Array of recipes in the category

```lua
local potionRecipes = CraftingLibrary.getRecipesByCategory("Potions")
```
]=]
function CraftingLibrary.getRecipesByCategory(category: string): { CraftingRecipe }
	local categoryRecipes = {}
	for _, recipe in pairs(recipes) do
		if recipe.category == category then
			table.insert(categoryRecipes, recipe)
		end
	end
	return categoryRecipes
end

--[=[
Gets a specific recipe by ID

@within CraftingLibrary

@param recipeId string -- The recipe ID

@return CraftingRecipe? -- The recipe if it exists

```lua
local recipe = CraftingLibrary.getRecipe("craft_health_potion")
```
]=]
function CraftingLibrary.getRecipe(recipeId: string): CraftingRecipe?
	return recipes[recipeId]
end

--[=[
Checks if a recipe can be crafted with current inventory

@within CraftingLibrary

@param recipeId string -- The recipe ID
@param playerInventory { [string]: number } -- Player's inventory
@param playerLevel number -- Player's level

@return boolean -- Whether the recipe can be crafted

```lua
local canCraft = CraftingLibrary.canCraft("craft_health_potion", inventory, 10)
```
]=]
function CraftingLibrary.canCraft(recipeId: string, playerInventory: { [string]: number }, playerLevel: number): boolean
	local recipe = recipes[recipeId]
	if not recipe then
		return false
	end

	-- Check level requirement
	if recipe.unlockLevel and playerLevel < recipe.unlockLevel then
		return false
	end

	-- Check ingredient requirements
	for ingredientId, requiredAmount in pairs(recipe.ingredients) do
		local playerAmount = playerInventory[ingredientId] or 0
		if playerAmount < requiredAmount then
			return false
		end
	end

	return true
end

--[=[
Crafts an item using a recipe

@within CraftingLibrary

@param recipeId string -- The recipe ID
@param playerInventory { [string]: number } -- Player's inventory (will be modified)
@param playerLevel number -- Player's level

@return CraftingResult -- The result of the crafting attempt

```lua
local result = CraftingLibrary.craftItem("craft_health_potion", inventory, 10)
```
]=]
function CraftingLibrary.craftItem(
	recipeId: string,
	playerInventory: { [string]: number },
	playerLevel: number
): CraftingResult
	-- Check if crafting is possible
	if not CraftingLibrary.canCraft(recipeId, playerInventory, playerLevel) then
		return {
			success = false,
			error = "Crafting requirements not met",
		}
	end

	local recipe = recipes[recipeId]
	if not recipe then
		return {
			success = false,
			error = "Recipe not found",
		}
	end

	local costsApplied = {}

	-- Apply ingredient costs
	for ingredientId, requiredAmount in pairs(recipe.ingredients) do
		playerInventory[ingredientId] = playerInventory[ingredientId] - requiredAmount
		costsApplied[ingredientId] = requiredAmount
	end

	-- Add result to inventory
	playerInventory[recipe.resultItem] = (playerInventory[recipe.resultItem] or 0) + recipe.resultQuantity

	return {
		success = true,
		resultItem = recipe.resultItem,
		resultQuantity = recipe.resultQuantity,
		costsApplied = costsApplied,
	}
end

--[=[
Gets available recipes for a player based on level

@within CraftingLibrary

@param playerLevel number -- Player's level

@return { CraftingRecipe } -- Array of available recipes

```lua
local availableRecipes = CraftingLibrary.getAvailableRecipes(15)
```
]=]
function CraftingLibrary.getAvailableRecipes(playerLevel: number): { CraftingRecipe }
	local available = {}
	for _, recipe in pairs(recipes) do
		if not recipe.unlockLevel or playerLevel >= recipe.unlockLevel then
			table.insert(available, recipe)
		end
	end
	return available
end

return CraftingLibrary
