local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Hard to hit",
	PassiveDescription = "This unit immune to boss attacks",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag("InnateNonTarget")
	end,
}

return Passive