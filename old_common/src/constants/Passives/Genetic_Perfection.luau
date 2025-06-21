local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Genetic Perfection",
	PassiveDescription = "for every 10 eliminations his critical chance gets increased by 1% up to 20%. At max stacks his critical dmg gets increased by 20%",
}

Passive.callbacks = {

	onKill = function(self, Unit: Model)
		
		local Stacks = Unit:GetAttribute(`PerfectionStacks`) or 0
		local DStacks = Unit:GetAttribute(`DPerfectionStacks`) or 0
		local Activated = Unit:GetAttribute(`SpaActived`) or false

		if Stacks >= 10 then
			Unit:SetAttribute(`PerfectionStacks`, 0)
			if DStacks < 0.15 then
				Unit:SetAttribute(`DPerfectionStacks`, DStacks+0.01)
				Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+0.01)
				warn("Critical Chance", Unit:GetAttribute("PermanentAttackCriticalChance"))
				--Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")+0.1)
				--warn("Attack Damage", Unit:GetAttribute("PermanentAttackCriticalDamage"))
			elseif DStacks >= 0.15 then
				Unit:SetAttribute(`SpaActived`, true)
			end
		end
		Unit:SetAttribute(`PerfectionStacks`, Stacks+1)
		
		if DStacks >= 0.15 and not Activated then
			Unit:SetAttribute(`SpaActived`, true)
			Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")+0.2)
		end
		
	end,

	--onConditionalDamage = function(self, Unit: Model, Enemy: {any})
	--	if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
	--		local HasStatus = Unit:GetAttribute("StunnedApplied")

	--		if HasStatus then
	--			local Stacks = Unit:GetAttribute("BungeeStacks") or 0
	--			if Stacks < 0.05 then
	--				Unit:SetAttribute("BungeeStacks", Stacks+0.01)
	--				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Stacks)
	--			end
	--			return 3
	--		end
	--	end

	--	return 1
	--end,

}

return Passive
