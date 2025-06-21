local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Almighty Time Stop" :: string,
	AbilityImage = "rbxassetid://122958351137577",
	Description = "With the awakened Godly power, stops the time flow of enemies for 20 seconds. (MAP-WIDE) ; (GLOBAL COOLDOWN)",
	Cooldown = 300 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = true :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "Stop" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 2 :: number,
	Duration = 20 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility