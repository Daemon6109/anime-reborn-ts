local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Jay the Catboss" :: string,
	AbilityImage = "rbxassetid://18873417331",
	Cooldown = 22 :: number,
	IsSupport = true :: boolean,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "Money" :: Enums.SpecialAbilityTypes,
	AbilityData = {
		Money = 100000000000,
	},
	Windup = 1 :: number,
	Duration = 0 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility