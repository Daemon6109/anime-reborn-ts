local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local SpecialAbility = {}
setmetatable(SpecialAbility, {__index = require(replicated.Registry.SpecialAbilityBaseMethods)})

SpecialAbility.configuration = {
	DisplayName = "Delta Force: Core Breaker" :: string,
	AbilityImage = "rbxassetid://92037185591338",
	Description = "Heroically sacrificing himself, one of the brothers causes a map-wide Nuke explosion, dealing 15% damage to enemies (out of their MAX HP), dealing damage to foes, and increasing his remaining brother's DMG by +15%, and RNG by +5% for 800s. (GLOBAL CD)",
	Cooldown = 800 :: number,
	Percent = .15 :: number,
	IsGlobalCooldown = true :: boolean,
	IsGlobalAbility = true :: boolean, --hits all or only in range
	CooldownGroup = "Nuke" :: Enums.SpecialCooldownGroups,
	AbilityType = "PercentDamage" :: Enums.SpecialAbilityTypes,
	--Damage = .99 :: number,
	Windup = 4.95 :: number,
	Duration = 1 :: number,
	Root = script :: ModuleScript,
	--Status = "Burning",
	--StatusDuration = 15,
	CustomCallback = function(Unit: Model)
		Unit:AddTag("CoreBreak")
		Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+.5)
		Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentDamageMulti")+.15)
		
		task.delay(600/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			Unit:RemoveTag("CoreBreak")
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-.5)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentDamageMulti")-.15)
		end)
	end,
}

SpecialAbility.HitConfig = {
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .35, -- delay between hits in a multi-hit move
}

return SpecialAbility