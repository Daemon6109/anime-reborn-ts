local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Turbocharger",
	PassiveDescription = "Striking at the speed of 100 KM/H, you leave your enemies with a `Paralysis` status for 3 seconds. Paralyzed enemies take +10% more DMG.",
} 

Passive.callbacks = {}

return Passive
