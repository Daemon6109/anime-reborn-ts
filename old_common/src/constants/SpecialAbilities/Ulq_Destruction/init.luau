local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "The Void's Final Judgment" :: string,
	AbilityImage = "rbxassetid://110868948016520",
	Description = "With a cold command, Ulquiorra unleashes The Void's Final Judgment . The world shatters and enemies vanish as the entire map is consumed by an all-consuming void. Does 10x Damage (global cd).",
	Cooldown = 300 :: number,
	Multiplier = 10 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = true :: boolean, --hits all or only in range
	CooldownGroup = "Nuke" :: Enums.SpecialCooldownGroups,
	AbilityType = "Damage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = .15 :: number,
	Duration = .6 :: number,
	Root = script :: ModuleScript,
	--Status = "",
	--StatusDuration = 3,
}

SpecialAbility.HitConfig = {
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
}

return SpecialAbility