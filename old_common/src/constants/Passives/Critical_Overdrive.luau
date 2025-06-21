local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Critical Overdrive",
	PassiveDescription = "50% Crit Chance + 75% Crit Damage",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:SetAttribute("PermanentAttackCriticalDamage", 1.75)
	end,
}

return Passive
