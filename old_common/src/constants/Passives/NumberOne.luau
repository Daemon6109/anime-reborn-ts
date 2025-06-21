local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "You Are Number 1",
	PassiveDescription = "Ihigo gains +4% attack damage",
	PercentIncrease = .04,
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		
		if config then
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease) 
		end
	end,
}

return Passive
