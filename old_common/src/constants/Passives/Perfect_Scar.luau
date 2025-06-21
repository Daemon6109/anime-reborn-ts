local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Perfect Scar",
	PassiveDescription = "This unit applies 'Scar' on all attacks that deals 15% of unit damage per tick, double of normal scar",
} 

-- Unit:SetAttribute("PassiveSlow", false)

Passive.callbacks = {

}

return Passive
