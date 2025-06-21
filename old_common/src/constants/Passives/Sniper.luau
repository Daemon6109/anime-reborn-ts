local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Sniper",
	PassiveDescription = "Each attack increases range by 1% (Max 15%)",
	PercentIncrease = .01
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)

		local alreadyAppliedBuff = Unit:GetAttribute("SniperPassiveAppliedBuff") or 0
		if alreadyAppliedBuff >= 1.15 then return end

		local config = Unit:WaitForChild("configuration", 10)

		if config then
			Unit:SetAttribute("SniperPassiveAppliedBuff", alreadyAppliedBuff + Passive.configuration.PercentIncrease)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+Passive.configuration.PercentIncrease) 
		end

		
	end
}

return Passive
