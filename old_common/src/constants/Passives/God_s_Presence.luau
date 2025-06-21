local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "God's Presence",
	PassiveDescription = "Inflicts `Fear` on enemies when hit, making them take 12% more DMG.",
}

Passive.callbacks = {}

return Passive
