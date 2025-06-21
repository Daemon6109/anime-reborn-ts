local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Rivals",
	PassiveDescription = "Sasuke gets +5% damage increase and -5% attack speed decrease.",
	PercentIncrease = .05,
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		if config then
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-Passive.configuration.PercentIncrease) 
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease) 

		end
	end,
}

return Passive
