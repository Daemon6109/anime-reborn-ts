local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Legendary Wrath",
	PassiveDescription = "+1% damage increase each attack, up to +50% boost",
	MaxPassiveStacks = 50,
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		local ToBuff = {"Damage"}
		local BrolyStacksDamage = Unit:GetAttribute("BrolyStacksDamage") or 0
		
		if BrolyStacksDamage < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("BrolyStacksDamage", BrolyStacksDamage+1)

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
