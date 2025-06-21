local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Unlimited Void" :: string,
	AbilityImage = "rbxassetid://18468127403",
	Cooldown = 500 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = true :: boolean, --hits all or only in range
	CooldownGroup = "Domains" :: Enums.SpecialCooldownGroups,
	AbilityType = "Stop" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 5 :: number,
	Duration = 6 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility