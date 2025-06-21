local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Frost Demon",
	PassiveDescription = "Applies 'Frost Bite' effect on all attacks."
} 

Passive.callbacks = {}

return Passive
