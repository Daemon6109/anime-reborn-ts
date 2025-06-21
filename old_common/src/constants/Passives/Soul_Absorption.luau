local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Soul Absorption",
	PassiveDescription = "Gains +1% damage each 5 eliminations, up to +12% boost",
	MaxPassiveStacks = 60,
	PercentPerStack = 0.01/5,
	--ProcChance = 25,
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("RimuruSoulAbsorptionStacks") or 0

		if Stacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("RimuruSoulAbsorptionStacks", Stacks+1)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentPerStack)
		end
	end,
}

return Passive
