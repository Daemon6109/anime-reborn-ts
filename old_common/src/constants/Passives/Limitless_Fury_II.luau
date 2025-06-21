local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Limitless Fury II",
	PassiveDescription = "Gohun’s attack power increases by 5% with each enemy defeated, up to 100%. The boost resets each wave, but once maxed, grants an extra +25% DMG for the rest of the game.",
	MaxPassiveStacks = 20,
	PercentPerStack = 0.05,
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("FuryStacks") or 0
		local FullFury = Unit:GetAttribute("FullFury") or false

		if Stacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("FuryStacks", Stacks+1)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentPerStack)
		end
		
		if Stacks == Passive.configuration.MaxPassiveStacks and not FullFury then
			Unit:SetAttribute("FullFury", true)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.25)
		end
	end,
	
	onWave = function(self, Unit:Model)
		local Stacks = Unit:GetAttribute("FuryStacks") or 0
		
		if Stacks > 0 then
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti") - (Passive.configuration.PercentPerStack * Stacks))
			Unit:SetAttribute("FuryStacks", 0)
		end
	end,
}

return Passive
