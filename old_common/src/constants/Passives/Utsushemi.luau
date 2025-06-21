local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Utsushemi",
	PassiveDescription = "Killing an enemy will give a -50% SPA buff for 2.5s, Cooldown : 10s.",
} 

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Mode = Unit:GetAttribute("UtsushemiMode") or false
		local OnCD = Unit:GetAttribute("UtsushemiModeCD") or false

		if Mode or OnCD then return end

		Unit:SetAttribute("UtsushemiMode", true)
		Unit:SetAttribute("UtsushemiModeCD", true)
		
		Unit:SetAttribute("CD", 0)

		Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.5) 

		task.delay(2.5/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
			Unit:SetAttribute("UtsushemiMode", false)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")+.5) 

			task.wait(10/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)

			Unit:SetAttribute("UtsushemiModeCD", nil)
		end)
	end
}

return Passive
