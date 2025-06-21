local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Royale Execution",
	PassiveDescription = "If an enemy is below 20% hp there is 15% chance for him to devour them and increase his dmg and range by 15% and decrease his spa by 5% for 10 seconds with 25 seconds cooldown.",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		local BuffLib = require(replicated.Libs.BuffLib)
		
		local OnCooldown = Unit:GetAttribute(`OnPerfectCD`) or false
		if OnCooldown then return 1 end
		
		if Enemy and Enemy.Health > 0 then
			local Chance = Random.new():NextNumber(0, 100)

			if Chance <= 20 then
				if Enemy.Health <= (Enemy.MaxHealth * 0.2) then
					
					Unit:SetAttribute(`OnPerfectCD`, true)
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.15)
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.15) 
					Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.05) 
					task.delay(10/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
						Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-0.15)
						Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")-0.15) 
						Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")+.05) 
					end)
					task.delay(25/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
						Unit:SetAttribute(`OnPerfectCD`, false)
					end)
					
					return 1+(Enemy.Health/BuffLib:GetDamage(Unit))
				end
			end
		end
		
		return 1
	end,
}

return Passive
