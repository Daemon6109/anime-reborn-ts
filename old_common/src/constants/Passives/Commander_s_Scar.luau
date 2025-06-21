local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Commander's Scar",
	PassiveDescription = "The unit applies `Scar` status on hit.",
} 

-- Unit:SetAttribute("PassiveSlow", false)

Passive.callbacks = {}

return Passive
