local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Employee of the Month",
	PassiveDescription = "Nonomi's CRIT CHANCE and CRIT DMG are increased by +15%",
	PercentIncrease = .15,
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")+Passive.configuration.PercentIncrease)
		Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+Passive.configuration.PercentIncrease)
	end,
}

return Passive
