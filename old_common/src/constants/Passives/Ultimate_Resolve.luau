local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Ultimate Resolve",
	PassiveDescription = "Unit does triple damage to bosses. (300% more damage to bosses)",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)

		if config then
			Unit:SetAttribute("PermanentDmgToBossMulti", Unit:GetAttribute("PermanentDmgToBossMulti")+3) 
		end
	end,
}

return Passive
