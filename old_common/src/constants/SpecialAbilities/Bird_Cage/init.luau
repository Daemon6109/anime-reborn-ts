local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Bird Cage" :: string,
	AbilityImage = "rbxassetid://73271547622559",
	Description = "String Mage attacks every enemy on the map 15 times dealing 1% of the enemy's max health each hit, 300s Cooldown (GLOBAL CD)",
	Cooldown = 300 :: number,
	Percent = .01 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = true :: boolean, --hits all or only in range
	CooldownGroup = "Nuke" :: Enums.SpecialCooldownGroups,
	AbilityType = "PercentDamage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 0.5 :: number,
	Duration = 1 :: number,
	Root = script :: ModuleScript,
	--Status = "Burning",
	--StatusDuration = 15,
}

SpecialAbility.HitConfig = {
	HitCount = 15, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
}

return SpecialAbility