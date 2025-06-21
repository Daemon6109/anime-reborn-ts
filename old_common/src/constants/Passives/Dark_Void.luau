local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Dark Void",
	PassiveDescription = "With each attack applies `Slow` status.",
} 

Passive.callbacks = {}

return Passive
