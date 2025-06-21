local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Triple Blade",
	PassiveDescription = "Zoro gains 10% attack damage.",
	PercentIncrease = .1,
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
