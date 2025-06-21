local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Hitman",
	PassiveDescription = "Gains +0.1% more damage per elimination (MAX 15%)",
	MaxPassiveStacks = 150,
	PercentPerStack = 0.001,
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("HitmanStacks") or 0

		if Stacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("HitmanStacks", Stacks+1)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentPerStack)
		end
	end,
}

return Passive
