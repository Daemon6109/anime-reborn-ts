local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Room" :: string,
	AbilityImage = "rbxassetid://86357188237449",
	Description = "Sentinel uses his powers summoning a massive room dealing x10 damage to all enemies on the map, 500s Cooldown (GLOBAL CD)",
	Cooldown = 500 :: number,
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