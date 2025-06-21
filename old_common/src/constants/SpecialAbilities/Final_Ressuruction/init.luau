local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Final Ressuruction" :: string,
	AbilityImage = "rbxassetid://118971788437448",
	Description = "Using the power of his shadows, unleashes an immense power, dealing x25 of his DMG to all the enemies on the map. (GLOBAL CD)",
	Cooldown = 300 :: number,
	Multiplier = 25 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = true :: boolean, --hits all or only in range
	CooldownGroup = "Nuke" :: Enums.SpecialCooldownGroups,
	AbilityType = "Damage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 10 :: number,
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