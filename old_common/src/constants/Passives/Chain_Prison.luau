local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Chain Prison",
	PassiveDescription = "For each stunned enemy he kills, his range gets increased by 1% up to 15%, At max stacks his every 5th attack stun for 2 seconds. (5s cooldown)",
}

Passive.callbacks = {
	
	onAttack = function(self, Unit: Model)

		local OnCooldown = Unit:GetAttribute("PrisonCooldown") or false
		
		if not Unit:GetAttribute("StunEffectiveActive") then return end
		if OnCooldown then return end
		
		Unit:SetAttribute("PassiveStun", false)
		
		local PassiveStacks = Unit:GetAttribute("PassiveStacks") or 0
		
		if PassiveStacks >= 5 then
			Unit:SetAttribute("PassiveStacks", 0)
			Unit:SetAttribute("PrisonCooldown", true)
			Unit:SetAttribute("PassiveStun", true)
			task.delay(5, function()
				Unit:SetAttribute("PrisonCooldown", false)
			end)
		end
		Unit:SetAttribute("PassiveStacks", PassiveStacks + 1)

	end,
	
	--onConditionalDamage = function(self, Unit: Model, Enemy: {any})

	--	local Stacks = Unit:GetAttribute("StacksChainPrison") or 0
	--	local OnCooldown = Unit:GetAttribute("PrisonCooldown") or false
	--	if not Unit:GetAttribute("StunEffectiveActive") then return 1 end
		
	--	if Enemy and Enemy.Health > 0 then
	--		if Stacks >= 5 and not OnCooldown then
	--			Unit:SetAttribute("StacksChainPrison", 0)
	--			Unit:SetAttribute("PrisonCooldown", true)
	--			_G.Registry.registry.StatusEffects.Stun:OnServer(Unit, {Enemy}, 2)
	--		end
	--		Unit:SetAttribute("StacksChainPrison", Stacks+1)
	--	end
	--	return 1
	--end,


	onKill = function(self, Unit: Model, Enemy:{any}?)
		local Stacks = Unit:GetAttribute("RangeStacks") or 0

		if Stacks < 0.15 and Enemy.StatusEffects["Stun"] then
			Unit:SetAttribute("RangeStacks", Stacks+0.01)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.01)
		end

		if Stacks >= 0.15 then
			Unit:SetAttribute("StunEffectiveActive", true)
		end
	end,

}

return Passive
