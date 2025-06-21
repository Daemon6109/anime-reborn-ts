local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Surgeons precision",
	PassiveDescription = "Law becomes more powerful with every enemy defeated, increasing his damage by 0.1% per kill, up to a 10% cap.",
	MaxPassiveStacks = 100,
	PercentPerStack = 0.001,
} 

Passive.callbacks = {

	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("SurgeonStacks") or 0
		local StacksStop = Unit:GetAttribute("SurgeonStacksStop")

		if StacksStop then 

		else
			if Stacks < Passive.configuration.MaxPassiveStacks then
				Unit:SetAttribute("SurgeonStacks", Stacks+1)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentPerStack)
			end

			if Stacks == Passive.configuration.MaxPassiveStacks then
				Unit:SetAttribute("SurgeonStacksStop", true)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.1)
			end
		end
	end,

}

return Passive
