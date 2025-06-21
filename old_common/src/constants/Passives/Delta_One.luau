local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Delta One",
	PassiveDescription = "After every 5 hits, the Delta Brothers SPA decreases by 5%, down to -20%",
	MaxPassiveStacks = 4,
	PercentIncrease = 0.05,
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local DeltaOneStacks = Unit:GetAttribute("DeltaOneStacks") or 0
		local DeltaOneIncreaseStacks = Unit:GetAttribute("DeltaOneIncreaseStacks") or 0
		
		if DeltaOneIncreaseStacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("DeltaOneStacks", DeltaOneStacks+1)
			DeltaOneStacks = Unit:GetAttribute("DeltaOneStacks")
			
			if DeltaOneStacks == 5 then
				Unit:SetAttribute("DeltaOneIncreaseStacks", DeltaOneIncreaseStacks+1)
				Unit:SetAttribute("DeltaOneStacks", 0)
				Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-Passive.configuration.PercentIncrease)
				return
			end
		end
	end,
}

return Passive
