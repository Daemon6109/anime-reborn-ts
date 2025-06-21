local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Ennoodzuno" :: string,
	AbilityImage = "rbxassetid://97306784778544",
	Description = "Using the power of Poison Curse, enchances her physical strength, increasing DMG by +30% for 10 seconds.",
	Cooldown = 45 :: number,
	IsSupport = true :: boolean,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "Buffs" :: Enums.SpecialCooldownGroups,
	AbilityType = "BuffByElement" :: Enums.SpecialAbilityTypes,
	BuffData = {
		Damage = .3, -- %s
	} :: Enums.BuffData,
	Windup = 1 :: number,
	Duration = 10 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility