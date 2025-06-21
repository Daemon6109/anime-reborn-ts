local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Dragon Emperor: Flaming Wrath" :: string,
	AbilityImage = "rbxassetid://93251523993419",
	Description = "Transforms into the Mythical West Dragon and releases a rain of flaming projectiles, dealing x2.5 of his DMG and applying `Burning` status for 8 seconds.",
	Cooldown = 100 :: number,
	Multiplier = 2.5 :: number,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "Damage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 2 :: number,
	Duration = 3 :: number,
	Root = script :: ModuleScript,
	Status = "Burning",
	StatusDuration = 8,
}

SpecialAbility.HitConfig = {
	HitCount = 7, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}

return SpecialAbility