local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Burning Carnage II",
	PassiveDescription = "Applies `Dark Flames` status effect, burning by 12.5% of his damage per tick for 4 ticks",
} 

Passive.callbacks = {}

return Passive
