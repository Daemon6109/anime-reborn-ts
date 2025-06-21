local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Thunder Disciple",
	PassiveDescription = "Zenit deals +10% damage to bosses.",
	PercentIncrease = .10,
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		
		if config then
			Unit:SetAttribute("PermanentDmgToBossMulti", Unit:GetAttribute("PermanentDmgToBossMulti")+Passive.configuration.PercentIncrease) 
		end
	end,
}

return Passive
