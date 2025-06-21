local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Enhanced Durability",
	PassiveDescription = "Iron's armor makes him immune to stuns. Swinging his heavy hammer instantly breaks shields.",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag("ShieldBreaker")
		Unit:AddTag("InnateNonTarget")
		Unit:AddTag("InnateNoStun")
	end,
}

return Passive