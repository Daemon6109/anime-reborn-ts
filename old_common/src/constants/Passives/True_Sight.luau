local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "True Sight",
	PassiveDescription = "This unit is able to see thru 'Shade' enemy type enemies invulnerability",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag("TrueSight")
	end,
}

return Passive
