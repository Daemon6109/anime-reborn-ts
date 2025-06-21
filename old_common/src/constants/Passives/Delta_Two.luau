local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Delta Two",
	PassiveDescription = "After every 10 hits, the Delta Brothers DMG increases by 5%, up to +30%",
	MaxPassiveStacks = 6,
	PercentIncrease = 0.05,
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local DeltaTwoStacks = Unit:GetAttribute("DeltaTwoStacks") or 0
		local DeltaTwoIncreaseStacks = Unit:GetAttribute("DeltaTwoIncreaseStacks") or 0
		
		if DeltaTwoIncreaseStacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("DeltaTwoStacks", DeltaTwoStacks+1)
			DeltaTwoStacks = Unit:GetAttribute("DeltaTwoStacks")
			
			if DeltaTwoStacks == 10 then
				Unit:SetAttribute("DeltaTwoIncreaseStacks", DeltaTwoIncreaseStacks+1)
				Unit:SetAttribute("DeltaTwoStacks", 0)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease)
				return
			end
		end
	end,
}

return Passive
