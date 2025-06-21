--!strict
--------------------------------------------------------------------------------
-- Buffs Constants
-- Configuration for all buffs and debuffs in the game
--------------------------------------------------------------------------------

export type BuffData = {
	id: string,
	name: string,
	description: string,
	type: string,
	duration: number?,
	stackable: boolean,
	maxStacks: number?,
	effects: { [string]: any },
	visualEffect: string?,
}

local Buffs = {
	-- Damage buffs
	["strength_buff"] = {
		id = "strength_buff",
		name = "Strength",
		description = "Increases damage output",
		type = "Buff",
		duration = 60,
		stackable = false,
		effects = {
			damageMultiplier = 1.25,
		},
		visualEffect = "StrengthAura",
	},

	["rage_buff"] = {
		id = "rage_buff",
		name = "Rage",
		description = "Stacking damage increase",
		type = "Buff",
		duration = 30,
		stackable = true,
		maxStacks = 10,
		effects = {
			damageMultiplierPerStack = 0.05,
		},
		visualEffect = "RageParticles",
	},

	-- Speed buffs
	["haste_buff"] = {
		id = "haste_buff",
		name = "Haste",
		description = "Increases attack speed",
		type = "Buff",
		duration = 45,
		stackable = false,
		effects = {
			attackSpeedMultiplier = 1.30,
		},
		visualEffect = "HasteTrail",
	},

	["frenzy_buff"] = {
		id = "frenzy_buff",
		name = "Frenzy",
		description = "Dramatically increases attack speed",
		type = "Buff",
		duration = 15,
		stackable = false,
		effects = {
			attackSpeedMultiplier = 2.0,
		},
		visualEffect = "FrenzyEffect",
	},

	-- Defense buffs
	["shield_buff"] = {
		id = "shield_buff",
		name = "Shield",
		description = "Reduces incoming damage",
		type = "Buff",
		duration = 120,
		stackable = false,
		effects = {
			damageReduction = 0.25,
		},
		visualEffect = "ShieldGlow",
	},

	["armor_buff"] = {
		id = "armor_buff",
		name = "Armor",
		description = "Stacking damage reduction",
		type = "Buff",
		duration = 90,
		stackable = true,
		maxStacks = 5,
		effects = {
			damageReductionPerStack = 0.05,
		},
		visualEffect = "ArmorPlating",
	},

	-- Healing buffs
	["regeneration_buff"] = {
		id = "regeneration_buff",
		name = "Regeneration",
		description = "Restores health over time",
		type = "Buff",
		duration = 60,
		stackable = false,
		effects = {
			healthPerSecond = 0.02, -- 2% per second
		},
		visualEffect = "HealingAura",
	},

	-- Debuffs
	["poison_debuff"] = {
		id = "poison_debuff",
		name = "Poison",
		description = "Deals damage over time",
		type = "Debuff",
		duration = 30,
		stackable = true,
		maxStacks = 3,
		effects = {
			damagePerSecondPerStack = 0.01, -- 1% per second per stack
		},
		visualEffect = "PoisonCloud",
	},

	["slow_debuff"] = {
		id = "slow_debuff",
		name = "Slow",
		description = "Reduces attack speed",
		type = "Debuff",
		duration = 20,
		stackable = false,
		effects = {
			attackSpeedMultiplier = 0.7,
		},
		visualEffect = "SlowEffect",
	},

	["weakness_debuff"] = {
		id = "weakness_debuff",
		name = "Weakness",
		description = "Reduces damage output",
		type = "Debuff",
		duration = 40,
		stackable = false,
		effects = {
			damageMultiplier = 0.75,
		},
		visualEffect = "WeaknessAura",
	},

	-- Special buffs
	["invincibility_buff"] = {
		id = "invincibility_buff",
		name = "Invincibility",
		description = "Immune to all damage",
		type = "Special",
		duration = 5,
		stackable = false,
		effects = {
			damageImmunity = true,
		},
		visualEffect = "InvincibilityGlow",
	},
}

return Buffs
