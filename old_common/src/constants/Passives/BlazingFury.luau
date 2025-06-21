local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Blazing Fury",
	PassiveDescription = "Applies 'Burning' effect on all attacks."
} 

Passive.callbacks = {}

return Passive
