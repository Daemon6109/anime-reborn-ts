local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Pure Endurance",
	PassiveDescription = "Immune to stuns.",
}

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag("InnateNoStun")
		--Unit:SetAttribute("NoStun", true)
	end,
}

return Passive
