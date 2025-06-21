local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Time Warp" :: string,
	AbilityImage = "rbxassetid://122958351137577",
	Description = "When this ability is used activate a 10 second time stop, after the end of Time Stop, increase damage taken by 20% (stacks with 10% from Gods Aura) by 5 seconds. (Global CD)",
	Cooldown = 260 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = true :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "WhisStop" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 2 :: number,
	Duration = 10 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility