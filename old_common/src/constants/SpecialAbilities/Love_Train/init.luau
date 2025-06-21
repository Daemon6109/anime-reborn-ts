local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Love Train" :: string,
	AbilityImage = "rbxassetid://86501896578741",
	Description = "Using Love Train places an multi-dimensional barrier on the base, making enemies not being able to reach it for 15s, ability windup is 5s.",
	Cooldown = 500 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = true :: boolean, --hits all or only in range
	CooldownGroup = "BaseSave" :: Enums.SpecialCooldownGroups,
	AbilityType = "LoveTrain" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Percent = .7,
	Windup = 5 :: number,
	Duration = 15 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility