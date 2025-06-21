local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Shock",
	PassiveDescription = "With each attack applies `Stun` status effect for 1.5s",
} 

Passive.callbacks = {}

return Passive
