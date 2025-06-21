local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Metralleta",
	PassiveDescription = "Every 10 hits, his next attack will deal x2 damage while applying permanent bleed, Also gains 1% crit damage each time this passive is used (Max 50%)",
	HitsNeeded = 10
}

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		local Stacks = Unit:GetAttribute("MetralletaStacks") or 0
		local Mode = Unit:GetAttribute("MetralletaMode") or false

		if Mode or not config then return end

		if Stacks < Passive.configuration.HitsNeeded then
			Unit:SetAttribute("MetralletaStacks", Stacks + 1)
		else
			Unit:SetAttribute("MetralletaStacks", 0)
			Unit:SetAttribute("MetralletaMode", true)

			local CritStacks = Unit:GetAttribute("MetralletaCritStacks") or 0

			if CritStacks < 50 then
				Unit:SetAttribute("MetralletaCritStacks", CritStacks + 1)
				Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage") + 0.01)
			end
		end
	end,
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Unit:GetAttribute("MetralletaMode") then
			_G.Registry.registry.StatusEffects.PermaBleed:OnServer(Unit, {Enemy}, 999)
			return 2
		end

		return 1
	end,
	onAttackEnded = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		if not config then return end

		if Unit:GetAttribute("MetralletaMode") then
			Unit:SetAttribute("MetralletaMode", nil)
		end
	end,
}

return Passive
