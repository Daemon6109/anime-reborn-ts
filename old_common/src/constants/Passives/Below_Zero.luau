local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Below Zero",
	PassiveDescription = "With each attack freezes enemies for 3 seconds.",
} 

Passive.callbacks = {}

return Passive
