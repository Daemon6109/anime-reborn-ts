local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Time Freeze" :: string,
	AbilityImage = "rbxassetid://115027077806236",
	Description = "Using Time Magic, causes a local time-stop within his range, stopping enemies for 9s.",
	Cooldown = 75 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "General" :: Enums.SpecialCooldownGroups,
	AbilityType = "Stop" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 0 :: number,
	Duration = 9 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility