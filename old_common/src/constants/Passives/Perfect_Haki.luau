local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Perfect Haki",
	PassiveDescription = "Hits ignore/break shields from enemies, dealing damage towards them instantly."
} 

Passive.callbacks = {
	
	onPlace = function(self, Unit: Model)
		Unit:AddTag("ShieldBreaker")
	end,
	
	
}

return Passive
