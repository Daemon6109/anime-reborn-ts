local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Divine Enlightenment",
	PassiveDescription = "Gain Damage by 1% with each enemy defeated, up to 15%. The boost resets each wave, but once maxed, his spa is decreased by 5% permanently.",
}

Passive.callbacks = {

	onKill = function(self, Unit: Model)

		local DStacks = Unit:GetAttribute(`DPerfectionStacks`) or 0
		local Activated = Unit:GetAttribute(`SpaActived`) or false

		if DStacks < 0.15 then
			Unit:SetAttribute(`DPerfectionStacks`, DStacks+0.01)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.01)
		end
		
		if DStacks >= 0.15 and not Activated then
			Unit:SetAttribute(`SpaActived`, true)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.05) 
		end

	end,
	
	onWave = function(self, Unit:Model)
		local DStacks = Unit:GetAttribute(`DPerfectionStacks`) or 0
		if DStacks > 0 then
			Unit:SetAttribute(`DPerfectionStacks`, 0)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-DStacks)
		end
	end,

}

return Passive
