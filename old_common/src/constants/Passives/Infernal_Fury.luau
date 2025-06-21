local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Infernal Fury",
	PassiveDescription = "Applies `Burning` status effect on hit",
} 

Passive.callbacks = {}

return Passive
