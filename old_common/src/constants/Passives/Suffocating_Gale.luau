local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Suffocating Gale",
	PassiveDescription = "With each attack applies `Suffocation` status effect, slowing down the target by 50%, lasting 15 seconds and has a per-enemy application cooldown of 15 seconds.",
} 

Passive.callbacks = {}

return Passive
