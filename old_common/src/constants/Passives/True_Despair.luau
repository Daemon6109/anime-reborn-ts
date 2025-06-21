local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "True Despair",
	PassiveDescription = "After 15 eliminations, he gains 10% damage and range buff while applying Fear on hit, Lasts for 10s. Cooldown : 25s",
	KillsNeeded = 15
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("TrueDespairStacks") or 0
		local Mode = Unit:GetAttribute("TrueDespairMode") or false
		local OnCD = Unit:GetAttribute("TrueDespairModeCD") or false

		local config = Unit:WaitForChild("configuration", 10)
		
		if Mode or OnCD or not config then return end

		if Stacks < Passive.configuration.KillsNeeded then
			Unit:SetAttribute("TrueDespairStacks", Stacks + 1)
		else
			Unit:SetAttribute("TrueDespairStacks", 0)
			Unit:SetAttribute("TrueDespairMode", true)

			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti") + .1)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti") + .1)

			local OldAttackEffect, OldEffectDuration = config.AttackEffect.Value, config.AttackEffectDuration.Value

			config.AttackEffect.Value = "Fear"
			config.AttackEffectDuration.Value = 1
			
			task.delay(10/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute("TrueDespairMode", false)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti") - .1)
				Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti") - .1)

				Unit:SetAttribute("TrueDespairModeCD", true)

				config.AttackEffect.Value = OldAttackEffect
				config.AttackEffectDuration.Value = OldEffectDuration
				
				task.wait(25/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)

				Unit:SetAttribute("TrueDespairModeCD", nil)
			end)
		end
	end,
}

return Passive
