local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Eternal Frost: Buddha" :: string,
	AbilityImage = "rbxassetid://114199403214505",
	Description = "Summons a Frost Statue, dealing x2.5 of his DMG, applying `Frozen` status for 5 seconds.",
	Cooldown = 120 :: number,
	Multiplier = 2.5 :: number,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "Damage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 2.7 :: number,
	Duration = 1 :: number,
	Root = script :: ModuleScript,
	Status = "Frozen",
	StatusDuration = 5,
}

SpecialAbility.HitConfig = {
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}

return SpecialAbility