local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Precise Blows",
	PassiveDescription = "With each attack applies `Scar` status effect for 5 ticks.",
} 

Passive.callbacks = {}

return Passive
