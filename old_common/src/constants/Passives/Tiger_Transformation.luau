local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Tiger Transformation",
	PassiveDescription = "After 25 eliminations, he gains 18% damage buff and -18% spa, Lasts for 20s. Cooldown : 40s",
	KillsNeeded = 25
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("TigerStacks") or 0
		local Mode = Unit:GetAttribute("TigerMode") or false
		local OnCD = Unit:GetAttribute("TigerModeCD") or false
		
		if Mode or OnCD then return end

		if Stacks < Passive.configuration.KillsNeeded then
			Unit:SetAttribute("TigerStacks", Stacks+1)
		else
			Unit:SetAttribute("TigerStacks", 0)
			Unit:SetAttribute("TigerMode", true)
			
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+.18)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.10) 
			
			task.delay(20/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute("TigerMode", false)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-.18)
				Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")+.10) 
				
				Unit:SetAttribute("TigerModeCD", true)
				
				task.wait(40/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)
				
				Unit:SetAttribute("TigerModeCD", nil)
			end)
		end
	end,
}

return Passive
