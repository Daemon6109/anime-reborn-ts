local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Burning Carnage I",
	PassiveDescription = "Applies `Burning` status effect, burning by 10% of his damage per tick for 4 ticks",
} 

Passive.callbacks = {}

return Passive
