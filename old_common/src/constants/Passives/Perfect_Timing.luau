local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Perfect Timing",
	PassiveDescription = " After getting stunned, for the next 15 seconds his critical chance is increased by 35% and crit dmg by 15%. (30s CD)"
} 

Passive.callbacks = {

	onStunEnded = function(self, Unit: Model)

		local IsBuffed = Unit:GetAttribute("IsBuffedHitto") or false
		local OnCooldown = Unit:GetAttribute("IsBuffedHittoCD") or false
		
		if OnCooldown then return end
		
		if not IsBuffed then
			Unit:SetAttribute("IsBuffedHitto", true)
			Unit:SetAttribute("IsBuffedHittoCD", true)
			--Unit:AddTag("InnateNoStun")
			Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")+0.15) 
			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+0.35) 
			task.delay(15/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				--Unit:RemoveTag("InnateNoStun")
				Unit:SetAttribute("IsBuffedDoffy", false)
				Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")-0.15) 
				Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")-0.35) 
			end)
			task.delay(30/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute("IsBuffedHittoCD", false)
			end)
		end

	end,

}

return Passive
