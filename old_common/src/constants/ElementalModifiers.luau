--!strict
--------------------------------------------------------------------------------
-- ElementalModifiers Constants
-- Configuration for elemental damage and resistance modifiers
--------------------------------------------------------------------------------

export type ElementData = {
	id: string,
	name: string,
	color: Color3,
	description: string,
	weakAgainst: { string }?,
	strongAgainst: { string }?,
	damageMultiplier: number,
}

local ElementalModifiers = {
	-- Basic elements
	["fire"] = {
		id = "fire",
		name = "Fire",
		color = Color3.new(1, 0.3, 0),
		description = "Burns enemies with intense heat",
		weakAgainst = { "water", "ice" },
		strongAgainst = { "nature", "ice" },
		damageMultiplier = 1.0,
	},

	["water"] = {
		id = "water",
		name = "Water",
		color = Color3.new(0, 0.5, 1),
		description = "Flows around enemies with crushing force",
		weakAgainst = { "nature", "lightning" },
		strongAgainst = { "fire", "earth" },
		damageMultiplier = 1.0,
	},

	["earth"] = {
		id = "earth",
		name = "Earth",
		color = Color3.new(0.6, 0.4, 0.2),
		description = "Crushes foes with solid stone",
		weakAgainst = { "water", "nature" },
		strongAgainst = { "lightning", "wind" },
		damageMultiplier = 1.0,
	},

	["wind"] = {
		id = "wind",
		name = "Wind",
		color = Color3.new(0.8, 0.9, 1),
		description = "Cuts through enemies with sharp gusts",
		weakAgainst = { "earth", "fire" },
		strongAgainst = { "lightning", "ice" },
		damageMultiplier = 1.0,
	},

	-- Advanced elements
	["lightning"] = {
		id = "lightning",
		name = "Lightning",
		color = Color3.new(1, 1, 0),
		description = "Strikes with electrical energy",
		weakAgainst = { "earth", "wind" },
		strongAgainst = { "water", "metal" },
		damageMultiplier = 1.2,
	},

	["ice"] = {
		id = "ice",
		name = "Ice",
		color = Color3.new(0.7, 0.9, 1),
		description = "Freezes enemies in place",
		weakAgainst = { "fire", "lightning" },
		strongAgainst = { "water", "nature" },
		damageMultiplier = 1.1,
	},

	["nature"] = {
		id = "nature",
		name = "Nature",
		color = Color3.new(0, 0.8, 0),
		description = "Entangles foes with living vines",
		weakAgainst = { "fire", "ice" },
		strongAgainst = { "earth", "water" },
		damageMultiplier = 1.1,
	},

	-- Rare elements
	["dark"] = {
		id = "dark",
		name = "Dark",
		color = Color3.new(0.2, 0, 0.4),
		description = "Corrupts enemies with shadow energy",
		weakAgainst = { "light", "holy" },
		strongAgainst = { "psychic", "ghost" },
		damageMultiplier = 1.3,
	},

	["light"] = {
		id = "light",
		name = "Light",
		color = Color3.new(1, 1, 0.8),
		description = "Purifies enemies with radiant energy",
		weakAgainst = { "dark", "void" },
		strongAgainst = { "dark", "undead" },
		damageMultiplier = 1.3,
	},

	["metal"] = {
		id = "metal",
		name = "Metal",
		color = Color3.new(0.7, 0.7, 0.8),
		description = "Pierces through defenses",
		weakAgainst = { "lightning", "fire" },
		strongAgainst = { "earth", "ice" },
		damageMultiplier = 1.2,
	},

	-- Legendary elements
	["void"] = {
		id = "void",
		name = "Void",
		color = Color3.new(0.1, 0, 0.2),
		description = "Erases enemies from existence",
		weakAgainst = { "cosmic", "divine" },
		strongAgainst = { "light", "holy" },
		damageMultiplier = 1.5,
	},

	["cosmic"] = {
		id = "cosmic",
		name = "Cosmic",
		color = Color3.new(0.4, 0.2, 0.8),
		description = "Harnesses the power of stars",
		weakAgainst = { "void", "chaos" },
		strongAgainst = { "all" },
		damageMultiplier = 1.7,
	},

	-- Neutral
	["physical"] = {
		id = "physical",
		name = "Physical",
		color = Color3.new(0.5, 0.5, 0.5),
		description = "Pure physical damage",
		damageMultiplier = 1.0,
	},
}

-- Helper functions for calculating elemental effectiveness
local function getEffectiveness(attackerElement: string, defenderElement: string): number
	local attacker = ElementalModifiers[attackerElement]
	if not attacker then
		return 1.0
	end

	if attacker.strongAgainst and table.find(attacker.strongAgainst, defenderElement) then
		return 1.5
	elseif attacker.weakAgainst and table.find(attacker.weakAgainst, defenderElement) then
		return 0.5
	else
		return 1.0
	end
end

ElementalModifiers.getEffectiveness = getEffectiveness

return ElementalModifiers
