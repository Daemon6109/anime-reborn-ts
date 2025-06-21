local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Grace of Agility" :: string,
	AbilityImage = "rbxassetid://18864972760",
	Cooldown = 65 :: number,
	IsSupport = true :: boolean,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "Buffs" :: Enums.SpecialCooldownGroups,
	AbilityType = "Buff" :: Enums.SpecialAbilityTypes,
	BuffData = {
		AttackSpeed = 25/100, -- %s
		Range = 45/100,
	} :: Enums.BuffData,
	Windup = 1 :: number,
	Duration = 30 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility