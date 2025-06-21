--!strict
--------------------------------------------------------------------------------
-- Skins Constants
-- Configuration for all unit skins in the game
--------------------------------------------------------------------------------

export type SkinData = {
	id: string,
	name: string,
	unitId: string,
	rarity: string,
	description: string,
	effects: { string }?,
	unlockMethod: string,
	cost: number?,
}

local Skins = {
	-- Basic Swordsman skins
	["basic_swordsman_gold"] = {
		id = "basic_swordsman_gold",
		name = "Golden Swordsman",
		unitId = "basic_swordsman",
		rarity = "Rare",
		description = "A golden variant of the basic swordsman",
		effects = { "GoldenGlow" },
		unlockMethod = "Purchase",
		cost = 500,
	},

	["basic_swordsman_shadow"] = {
		id = "basic_swordsman_shadow",
		name = "Shadow Swordsman",
		unitId = "basic_swordsman",
		rarity = "Epic",
		description = "A dark variant with shadow powers",
		effects = { "ShadowTrail", "DarkAura" },
		unlockMethod = "Event",
	},

	-- Fire Mage skins
	["fire_mage_ice"] = {
		id = "fire_mage_ice",
		name = "Ice Mage",
		unitId = "fire_mage",
		rarity = "Epic",
		description = "Ice variant of the fire mage",
		effects = { "FrozenEffect", "IceParticles" },
		unlockMethod = "Achievement",
	},

	["fire_mage_rainbow"] = {
		id = "fire_mage_rainbow",
		name = "Rainbow Mage",
		unitId = "fire_mage",
		rarity = "Legendary",
		description = "Multicolored magical variant",
		effects = { "RainbowTrail", "Sparkles", "ColorShift" },
		unlockMethod = "Premium",
		cost = 2000,
	},

	-- Dragon Knight skins
	["dragon_knight_ancient"] = {
		id = "dragon_knight_ancient",
		name = "Ancient Dragon Knight",
		unitId = "dragon_knight",
		rarity = "Legendary",
		description = "An ancient and powerful variant",
		effects = { "AncientRunes", "DragonFlames" },
		unlockMethod = "Raid",
	},

	-- Celestial Warrior skins
	["celestial_warrior_void"] = {
		id = "celestial_warrior_void",
		name = "Void Warrior",
		unitId = "celestial_warrior",
		rarity = "Mythic",
		description = "A warrior from the void realm",
		effects = { "VoidPortal", "CosmicAura", "StarField" },
		unlockMethod = "Special",
	},
}

return Skins
