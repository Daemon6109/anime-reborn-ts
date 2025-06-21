local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Critical Striker",
	PassiveDescription = "Breaks enemy shields instantly.",
} 

Passive.callbacks = {
	
	onPlace = function(self, Unit: Model)
		Unit:AddTag("ShieldBreaker")
	end,
	
}

return Passive
