local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Adaptive",
	PassiveDescription = "Tashrio can be placed on both ground and hills.",
} 

Passive.callbacks = {}

return Passive
