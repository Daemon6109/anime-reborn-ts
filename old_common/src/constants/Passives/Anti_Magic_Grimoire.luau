local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Anti-Magic Grimoire",
	PassiveDescription = "Osta’s Anti-Magic Grimoire causes bosses to fear him, preventing them from attacking and stunning him. His anti-magic sword easily destroys shields.",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag("ShieldBreaker")
		Unit:AddTag("InnateNonTarget")
		Unit:AddTag("InnateNoStun")
	end,
}

return Passive