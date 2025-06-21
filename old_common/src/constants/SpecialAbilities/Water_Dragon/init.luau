local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Water Dragon" :: string,
	AbilityImage = "rbxassetid://125878032783824",
	Cooldown = 90 :: number,
	Description = "Using the Art of Ninjutsu casts Water Dragons, dealing x4 of his DMG, and applies `Slow` status for 3s.",
	Multiplier = 4 :: number,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "Damage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 2.2 :: number,
	Duration = 3 :: number,
	Root = script :: ModuleScript,
	Status = "Slow",
	StatusDuration = 3,
}

SpecialAbility.HitConfig = {
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .35, -- delay between hits in a multi-hit move
}

return SpecialAbility