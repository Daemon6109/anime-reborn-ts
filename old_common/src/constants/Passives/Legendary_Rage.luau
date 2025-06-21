local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Legendary Rage",
	PassiveDescription = "+1% range increase each attack, up to +20% boost",
	MaxPassiveStacks = 20,
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		local ToBuff = {"Range"}
		local BrolyStacksRange = Unit:GetAttribute("BrolyStacksRange") or 0
		
		if BrolyStacksRange < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("BrolyStacksRange", BrolyStacksRange+1)

			for _, StatName in ToBuff do
				local CurrentBuff = Unit:GetAttribute(`Permanent{StatName}Multi`)

				if CurrentBuff then
					Unit:SetAttribute(`Permanent{StatName}Multi`, CurrentBuff+.01)
				end
			end
		end
	end,
}

return Passive
