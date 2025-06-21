local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Healing" :: string,
	AbilityImage = "rbxassetid://18873417331",
	Description = "Heals the base.",
	Cooldown = 90 :: number,
	IsSupport = true :: boolean,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "Heal" :: Enums.SpecialCooldownGroups,
	AbilityType = "Healing" :: Enums.SpecialAbilityTypes,
	AbilityData = {
		Heal = "Damage",-- can be a number or stat name
	},
	Windup = 3 :: number,
	Duration = 0 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility