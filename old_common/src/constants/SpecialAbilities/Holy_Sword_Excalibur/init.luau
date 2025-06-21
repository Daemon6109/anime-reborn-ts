local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Holy Sword: Excalibur" :: string,
	AbilityImage = "rbxassetid://109209494536924",
	Description = "Unleashing Excalibur's holy power, deals x3 of her DMG.",
	Cooldown = 120 :: number,
	Multiplier = 3 :: number,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "Damage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 2 :: number,
	Duration = 3 :: number,
	Root = script :: ModuleScript,
	--Status = "",
	--StatusDuration = 3,
}

SpecialAbility.HitConfig = {
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}

return SpecialAbility