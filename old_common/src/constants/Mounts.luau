--!strict
--------------------------------------------------------------------------------
-- Mounts Constants
-- Configuration for all mounts in the game
--------------------------------------------------------------------------------

export type MountData = {
	id: string,
	name: string,
	type: string,
	rarity: string,
	description: string,
	speed: number,
	effects: { string }?,
	unlockMethod: string,
	cost: number?,
}

local Mounts = {
	-- Basic mounts
	["horse"] = {
		id = "horse",
		name = "Basic Horse",
		type = "Land",
		rarity = "Common",
		description = "A reliable steed for travel",
		speed = 1.2,
		unlockMethod = "Default",
	},

	["pony"] = {
		id = "pony",
		name = "Cute Pony",
		type = "Land",
		rarity = "Common",
		description = "A small but adorable mount",
		speed = 1.1,
		effects = { "CuteParticles" },
		unlockMethod = "Purchase",
		cost = 500,
	},

	-- Rare mounts
	["unicorn"] = {
		id = "unicorn",
		name = "Mystical Unicorn",
		type = "Magic",
		rarity = "Rare",
		description = "A magical creature with a horn",
		speed = 1.5,
		effects = { "RainbowTrail", "Sparkles" },
		unlockMethod = "Quest",
	},

	["wolf"] = {
		id = "wolf",
		name = "Shadow Wolf",
		type = "Beast",
		rarity = "Rare",
		description = "A fierce companion from the wild",
		speed = 1.4,
		effects = { "ShadowTrail" },
		unlockMethod = "Achievement",
	},

	-- Epic mounts
	["dragon"] = {
		id = "dragon",
		name = "Fire Dragon",
		type = "Dragon",
		rarity = "Epic",
		description = "A mighty dragon that can fly",
		speed = 2.0,
		effects = { "DragonFlames", "Flight" },
		unlockMethod = "Raid",
	},

	["phoenix"] = {
		id = "phoenix",
		name = "Celestial Phoenix",
		type = "Mythical",
		rarity = "Epic",
		description = "A legendary bird of rebirth",
		speed = 1.8,
		effects = { "PhoenixFlames", "Resurrection", "Flight" },
		unlockMethod = "Premium",
		cost = 2000,
	},

	-- Legendary mounts
	["void_steed"] = {
		id = "void_steed",
		name = "Void Steed",
		type = "Cosmic",
		rarity = "Legendary",
		description = "A mount from the void realm",
		speed = 2.5,
		effects = { "VoidTrail", "Teleportation", "PhaseWalk" },
		unlockMethod = "Special",
	},
}

return Mounts
