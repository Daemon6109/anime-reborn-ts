local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Poison Magic",
	PassiveDescription = "With each attack this unit applies `Poison` status effect, lasts for 25 seconds.",
} 

Passive.callbacks = {}

return Passive
