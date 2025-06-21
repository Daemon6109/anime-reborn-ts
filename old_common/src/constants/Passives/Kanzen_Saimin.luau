local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Kanzen Saimin",
	PassiveDescription = "After 20 eliminations, his next attack will apply Dark Flames",
	KillsNeeded = 15
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("KanzenSaiminStacks") or 0
		local Mode = Unit:GetAttribute("KanzenSaiminMode") or false

		local config = Unit:WaitForChild("configuration", 10)

		if Mode or not config then return end

		if Stacks < Passive.configuration.KillsNeeded then
			Unit:SetAttribute("KanzenSaiminStacks", Stacks + 1)
		else
			Unit:SetAttribute("KanzenSaiminStacks", 0)
			Unit:SetAttribute("KanzenSaiminMode", true)
		end
	end,
	onAttack = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		if not config then return end

		if Unit:GetAttribute("KanzenSaiminMode") then
			
			if not Unit:GetAttribute("KanzenSaiminOldAttackEffect") then
				Unit:SetAttribute("KanzenSaiminOldAttackEffect", config.AttackEffect.Value)
				Unit:SetAttribute("KanzenSaiminOldAttackDuration", config.AttackEffectDuration.Value)
			end

			config.AttackEffect.Value = "Dark Flames"
			config.AttackEffectDuration.Value = 5
		end
	end,
	onAttackEnded = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		if not config then return end

		if Unit:GetAttribute("KanzenSaiminMode") then
			local oldAttackEffect = Unit:GetAttribute("KanzenSaiminOldAttackEffect")
			local oldAttackDuration = Unit:GetAttribute("KanzenSaiminOldAttackDuration")

			if oldAttackEffect then
				config.AttackEffect.Value = oldAttackEffect
			end
			if oldAttackDuration then
				config.AttackEffectDuration.Value = oldAttackDuration
			end

			Unit:SetAttribute("KanzenSaiminMode", nil)
			Unit:SetAttribute("KanzenSaiminOldAttackEffect", nil)
			Unit:SetAttribute("KanzenSaiminOldAttackDuration", nil)
		end
	end,
}

return Passive
