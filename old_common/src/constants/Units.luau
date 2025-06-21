--!strict
--------------------------------------------------------------------------------
-- Units Constants
-- Configuration for all units in the game
--------------------------------------------------------------------------------

export type UnitData = {
	id: string,
	name: string,
	rarity: string,
	cost: number,
	damage: number,
	range: number,
	attackSpeed: number,
	series: string,
}

local Units = {
	-- Basic units
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

	["basic_archer"] = {
		id = "basic_archer",
		name = "Basic Archer",
		rarity = "Common",
		cost = 150,
		damage = 40,
		range = 3,
		attackSpeed = 1.2,
		series = "Starter",
	},

	-- Rare units
	["fire_mage"] = {
		id = "fire_mage",
		name = "Fire Mage",
		rarity = "Rare",
		cost = 500,
		damage = 120,
		range = 2,
		attackSpeed = 0.8,
		series = "Elements",
	},

	-- Epic units
	["dragon_knight"] = {
		id = "dragon_knight",
		name = "Dragon Knight",
		rarity = "Epic",
		cost = 1200,
		damage = 300,
		range = 1,
		attackSpeed = 0.6,
		series = "Dragons",
	},

	-- Legendary units
	["celestial_warrior"] = {
		id = "celestial_warrior",
		name = "Celestial Warrior",
		rarity = "Legendary",
		cost = 5000,
		damage = 800,
		range = 2,
		attackSpeed = 0.5,
		series = "Celestial",
	},
}

return Units
