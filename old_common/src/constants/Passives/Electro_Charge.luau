local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Electro Charge",
	PassiveDescription = "Every 6 attacks, this unit enters an enraged state for xx seconds, gaining 50% increased range. During this state, each kill boosts its damage by 1%, up to a maximum of 7%.",
}

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local PassiveStacks = Unit:GetAttribute("PassiveStacks") or 0
		local PassiveTrue = Unit:GetAttribute("PassiveTrue")

		if PassiveTrue then
			Unit:SetAttribute("PassiveTrue", false)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")-0.5) 
		else
			Unit:SetAttribute("PassiveStacks", PassiveStacks + 1)
		end

		if PassiveStacks > 5 and not PassiveTrue then
			Unit:SetAttribute("PassiveTrue", true)
			Unit:SetAttribute("PassiveStacks", 0)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.5) 
		end
	end,
	
	onKill = function(self: {any}, Unit: Model, Enemy: {any}?)
		if Unit:GetAttribute("PassiveTrue") then
			local Stacks = Unit:GetAttribute("ElectroChargeKillStacks") or 0
			
			if Stacks < 7 then
				Unit:SetAttribute("ElectroChargeKillStacks", Stacks + 1)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.01) 
			end
		end
	end,
}

return Passive
