local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Crystallized Mana",
	PassiveDescription = "Unit attacks ignores enemy elements damage debuffs.",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag("IgnoreElementsDebuff")
	end,
}

return Passive
