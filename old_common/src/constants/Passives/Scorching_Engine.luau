local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Scorching Engine",
	PassiveDescription = "With each attack Jenos applies `Burning` status effect, lasts for 5 seconds",
} 

Passive.callbacks = {}

return Passive
