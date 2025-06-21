local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Grace of Might" :: string,
	AbilityImage = "rbxassetid://107241719912180",
	Description = "Channeling her Godly power buffs her fellow adventurer's DMG and RNG by +15% for 45s.",
	Cooldown = 80 :: number,
	IsSupport = true :: boolean,
	IsGlobalCooldown = false :: boolean,
	IsGlobalAbility = false :: boolean, --hits all or only in range
	CooldownGroup = "Buffs" :: Enums.SpecialCooldownGroups,
	AbilityType = "Buff" :: Enums.SpecialAbilityTypes,
	BuffData = {
		Damage = 15/100, -- %s	
		Range = 15/100, -- %s	
	} :: Enums.BuffData,
	Windup = 1 :: number,
	Duration = 45 :: number,
	Root = script :: ModuleScript,
}

return SpecialAbility