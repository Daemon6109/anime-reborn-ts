local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "No Limits",
	PassiveDescription = "+15% increased range",
	PercentIncrease = .15,
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		
		if config then
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+Passive.configuration.PercentIncrease) 
		end
	end,
}

return Passive
