local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "All Range: Atomic" :: string,
	AbilityImage = "rbxassetid://118971788437448",
	Description = "Using the power of Nuclear Magic, unleashes an immense power, dealing x20 of his DMG to all the enemies on the map. (GLOBAL CD)",
	Cooldown = 300 :: number,
	Multiplier = 20 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = true :: boolean, --hits all or only in range
	CooldownGroup = "Nuke" :: Enums.SpecialCooldownGroups,
	AbilityType = "Damage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 2.95 :: number,
	Duration = .6 :: number,
	Root = script :: ModuleScript,
	--Status = "",
	--StatusDuration = 3,
}

SpecialAbility.HitConfig = {
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

return SpecialAbility