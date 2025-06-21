--!strict
--------------------------------------------------------------------------------
-- Potions Constants
-- Configuration for all potions and consumables in the game
--------------------------------------------------------------------------------

export type PotionData = {
	id: string,
	name: string,
	type: string,
	rarity: string,
	description: string,
	duration: number?,
	effects: { [string]: any },
	cost: number,
	stackable: boolean,
	maxStack: number?,
}

local Potions = {
	-- Health potions
	["health_potion_small"] = {
		id = "health_potion_small",
		name = "Small Health Potion",
		type = "Healing",
		rarity = "Common",
		description = "Restores 25% health instantly",
		effects = {
			heal = 0.25,
		},
		cost = 50,
		stackable = true,
		maxStack = 99,
	},

	["health_potion_large"] = {
		id = "health_potion_large",
		name = "Large Health Potion",
		type = "Healing",
		rarity = "Rare",
		description = "Restores 50% health instantly",
		effects = {
			heal = 0.50,
		},
		cost = 150,
		stackable = true,
		maxStack = 50,
	},

	-- Mana potions
	["mana_potion_small"] = {
		id = "mana_potion_small",
		name = "Small Mana Potion",
		type = "Mana",
		rarity = "Common",
		description = "Restores 30% mana instantly",
		effects = {
			manaRestore = 0.30,
		},
		cost = 60,
		stackable = true,
		maxStack = 99,
	},

	["mana_potion_large"] = {
		id = "mana_potion_large",
		name = "Large Mana Potion",
		type = "Mana",
		rarity = "Rare",
		description = "Restores 60% mana instantly",
		effects = {
			manaRestore = 0.60,
		},
		cost = 180,
		stackable = true,
		maxStack = 50,
	},

	-- Buff potions
	["strength_potion"] = {
		id = "strength_potion",
		name = "Strength Potion",
		type = "Buff",
		rarity = "Rare",
		description = "Increases damage by 25% for 60 seconds",
		duration = 60,
		effects = {
			damageMultiplier = 1.25,
		},
		cost = 200,
		stackable = true,
		maxStack = 20,
	},

	["speed_potion"] = {
		id = "speed_potion",
		name = "Speed Potion",
		type = "Buff",
		rarity = "Rare",
		description = "Increases attack speed by 30% for 45 seconds",
		duration = 45,
		effects = {
			attackSpeedMultiplier = 1.30,
		},
		cost = 180,
		stackable = true,
		maxStack = 20,
	},

	["defense_potion"] = {
		id = "defense_potion",
		name = "Defense Potion",
		type = "Buff",
		rarity = "Rare",
		description = "Reduces damage taken by 20% for 90 seconds",
		duration = 90,
		effects = {
			damageReduction = 0.20,
		},
		cost = 220,
		stackable = true,
		maxStack = 20,
	},

	-- Special potions
	["exp_boost_potion"] = {
		id = "exp_boost_potion",
		name = "Experience Boost Potion",
		type = "Special",
		rarity = "Epic",
		description = "Doubles experience gain for 30 minutes",
		duration = 1800,
		effects = {
			expMultiplier = 2.0,
		},
		cost = 500,
		stackable = true,
		maxStack = 10,
	},

	["luck_potion"] = {
		id = "luck_potion",
		name = "Luck Potion",
		type = "Special",
		rarity = "Epic",
		description = "Increases drop rates by 50% for 20 minutes",
		duration = 1200,
		effects = {
			dropRateMultiplier = 1.50,
		},
		cost = 600,
		stackable = true,
		maxStack = 10,
	},
}

return Potions
