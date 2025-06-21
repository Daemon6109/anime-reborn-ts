local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Ultra Instinct",
	PassiveDescription = "His instincts make him immune to stuns. (Unlocks on max transformation)",
} 

Passive.callbacks = {
	
	--onStunned = function(self, Unit: Model)
		
	--end,
	
	--onStunEnded = function(self, Unit: Model)
	--	local CriticalApplied = 
	--	Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+1)
	--end,
}

return Passive