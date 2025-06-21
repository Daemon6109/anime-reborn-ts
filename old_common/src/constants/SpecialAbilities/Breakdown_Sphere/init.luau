local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Breakdown Sphere" :: string,
	AbilityImage = "rbxassetid://108716801185518",
	Cooldown = 120 :: number,
	Multiplier = 1.5 :: number,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "Damage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 3 :: number,
	Duration = 2 :: number,
	Root = script :: ModuleScript,
	Status = "Dark Flames",
	StatusDuration = 16,
}

SpecialAbility.HitConfig = {
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}

return SpecialAbility