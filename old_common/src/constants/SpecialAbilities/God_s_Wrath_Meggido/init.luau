local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "God's Wrath: Meggido" :: string,
	AbilityImage = "rbxassetid://125878032783824",
	Description = "Focusing sun rays through water bubbles - releases precises shots of an immense power. Does x2 of their DMG and applies `Slow` status for 3s.",
	Cooldown = 90 :: number,
	Multiplier = 2 :: number,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "Damage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 4 :: number,
	Duration = 3 :: number,
	Root = script :: ModuleScript,
	Status = "Slow",
	StatusDuration = 3,
}

SpecialAbility.HitConfig = {
	HitCount = 7, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .35, -- delay between hits in a multi-hit move
}

return SpecialAbility