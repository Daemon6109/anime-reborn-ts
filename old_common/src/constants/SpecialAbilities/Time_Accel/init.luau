local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Time Accel" :: string,
	AbilityImage = "rbxassetid://97306784778544",
	Description = "Accelerates his brain processing speed, decreasing SPA by -30% for 10s.",
	Cooldown = 45 :: number,
	IsSupport = true :: boolean,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "Buffs" :: Enums.SpecialCooldownGroups,
	AbilityType = "SelfBuff" :: Enums.SpecialAbilityTypes,
	BuffData = {
		AttackSpeed = 30/100, -- %s
	} :: Enums.BuffData,
	Windup = 1 :: number,
	Duration = 10 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility