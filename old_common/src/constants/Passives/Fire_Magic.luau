local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Fire Magic",
	PassiveDescription = "With each attack this unit applies `Burn` status effect, lasts for 3 seconds.",
} 

Passive.callbacks = {}

return Passive
