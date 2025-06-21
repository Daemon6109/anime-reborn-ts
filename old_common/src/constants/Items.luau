--!strict
--------------------------------------------------------------------------------
-- Items Constants
-- Configuration for all items in the game
--------------------------------------------------------------------------------

export type ItemData = {
	id: string,
	name: string,
	type: string,
	rarity: string,
	description: string,
	stackable: boolean,
	maxStack: number?,
	value: number,
}

local Items = {
	-- Currency items
	["coins"] = {
		id = "coins",
		name = "Coins",
		type = "Currency",
		rarity = "Common",
		description = "Standard currency for purchases",
		stackable = true,
		value = 1,
	},

	["gems"] = {
		id = "gems",
		name = "Gems",
		type = "Currency",
		rarity = "Rare",
		description = "Premium currency for special purchases",
		stackable = true,
		value = 100,
	},

	-- Crates
	["basic_crate"] = {
		id = "basic_crate",
		name = "Basic Crate",
		type = "Crate",
		rarity = "Common",
		description = "Contains random common units",
		stackable = true,
		maxStack = 99,
		value = 50,
	},

	["special_crate"] = {
		id = "special_crate",
		name = "Special Crate",
		type = "Crate",
		rarity = "Rare",
		description = "Contains random rare units",
		stackable = true,
		maxStack = 50,
		value = 200,
	},

	["legendary_crate"] = {
		id = "legendary_crate",
		name = "Legendary Crate",
		type = "Crate",
		rarity = "Legendary",
		description = "Contains random legendary units",
		stackable = true,
		maxStack = 10,
		value = 1000,
	},

	-- Upgrade materials
	["upgrade_stone"] = {
		id = "upgrade_stone",
		name = "Upgrade Stone",
		type = "Material",
		rarity = "Common",
		description = "Used to upgrade units",
		stackable = true,
		maxStack = 999,
		value = 10,
	},

	["evolution_crystal"] = {
		id = "evolution_crystal",
		name = "Evolution Crystal",
		type = "Material",
		rarity = "Epic",
		description = "Used to evolve units to higher forms",
		stackable = true,
		maxStack = 100,
		value = 500,
	},

	-- Consumables
	["health_potion"] = {
		id = "health_potion",
		name = "Health Potion",
		type = "Consumable",
		rarity = "Common",
		description = "Restores health to units during battle",
		stackable = true,
		maxStack = 50,
		value = 25,
	},

	["mana_potion"] = {
		id = "mana_potion",
		name = "Mana Potion",
		type = "Consumable",
		rarity = "Common",
		description = "Restores mana to units during battle",
		stackable = true,
		maxStack = 50,
		value = 30,
	},
}

return Items
