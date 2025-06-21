local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Shrimp Boxing II",
	PassiveDescription = "Every 5th attack deals a 40% critical chance hit dealing +125% more critical damage",
	TagName = "Boxing",
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute(`{Passive.configuration.TagName}Stacks`) or 0
		
		if Stacks < 4 then
			Unit:SetAttribute(`{Passive.configuration.TagName}Stacks`, Stacks+1)
			return
		end
		
		Unit:SetAttribute(`{Passive.configuration.TagName}Stacks`, 0)
		Unit:AddTag(Passive.configuration.TagName)
		Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+.4)
		Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")+1.25)
	end,
	onAttackEnded = function(self, Unit: Model)
		if Unit:HasTag(Passive.configuration.TagName) then
			Unit:RemoveTag(Passive.configuration.TagName)
			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")-.4)
			Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")-1.25)
		end
	end,
}

return Passive
