local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Strongest Man Alive",
	PassiveDescription = "Greybeard gets +1% damage each wave, up to +20% boost",
	MaxPassiveStacks = 20,
} 

Passive.callbacks = {
	onWave = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		local ToBuff = {"Damage"}
		
		local StrongestManStacks = Unit:GetAttribute("StrongestManStacks") or 0
		
		if StrongestManStacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("StrongestManStacks", StrongestManStacks+1)
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
