local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Predator's Hunch",
	PassiveDescription = "After 30 eliminations, he gains 7.5% damage buff and -7.5% spa, Lasts for 25s. Cooldown : 35s",
	KillsNeeded = 30
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("PredatorHunchStacks") or 0
		local Mode = Unit:GetAttribute("PredatorHunchMode") or false
		local OnCD = Unit:GetAttribute("PredatorHunchCD") or false

		if Mode or OnCD then return end

		if Stacks < Passive.configuration.KillsNeeded then
			Unit:SetAttribute("PredatorHunchStacks", Stacks + 1)
		else
			Unit:SetAttribute("PredatorHunchStacks", 0)
			Unit:SetAttribute("PredatorHunchMode", true)

			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti") + 0.075)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti") - 0.075)

			task.delay(20/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute("PredatorHunchMode", false)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti") - 0.075)
				Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti") + 0.075)

				Unit:SetAttribute("PredatorHunchCD", true)

				task.wait(40/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)

				Unit:SetAttribute("PredatorHunchCD", nil)
			end)
		end
	end,
}

return Passive