local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Demon Lord",
	PassiveDescription = "Gains -1% SPA each wave up to -7% decrease, +2.5% damage for each special ability use up to +25% boost",
	MaxPassiveStacks = 10,
	PercentPerStack = 0.025,
	--ProcChance = 25,
}

Passive.callbacks = {
	onSpecialAbility = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("RimuruDemonLordStacks") or 0

		if Stacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("RimuruDemonLordStacks", Stacks+1)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentPerStack)
		end
	end,
	onWave = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("RimuruDemonLordWaveStacks") or 0

		if Stacks < 7 then
			Unit:SetAttribute("RimuruDemonLordWaveStacks", Stacks+1)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-0.01)
		end
	end,
}

return Passive
