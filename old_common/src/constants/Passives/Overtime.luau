local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Overtime",
	PassiveDescription = "Nonomi's attacks leave a `Weak Point` status effect on enemies, making them take +35% DMG for 10 seconds",
} 

Passive.callbacks = {}

return Passive
