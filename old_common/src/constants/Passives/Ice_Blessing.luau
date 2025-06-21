local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Ice Blessing",
	PassiveDescription = "Unit can't be targetted by Bosses and is Immune to Stuns.",
} 

Passive.callbacks = {

	onPlace = function(self, Unit: Model)
		Unit:AddTag("InnateNonTarget")
		Unit:AddTag("InnateNoStun")
	end,
	
}

return Passive