local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Saiyans Pride",
	PassiveDescription = "Each attack against boss enemy infuriates him, increasing his dmg by 0.2% up to 30% and resets on kill. (unlocks on max transformation)",
} 

Passive.callbacks = {

	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		
		--local OnCooldown = Unit:GetAttribute("PrisonCooldown") or false		
		--if OnCooldown then return end		
		local PassiveStacks = Unit:GetAttribute("PassiveStacks") or 0

		if Enemy and Enemy.Health > 0 then
			if Enemy.IsBoss then

				if PassiveStacks < 0.301 then
					Unit:SetAttribute("PassiveStacks", PassiveStacks + 0.02)
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.02)
					--Unit:SetAttribute("PrisonCooldown", true)
					--task.delay(2, function()
					--	Unit:SetAttribute("PrisonCooldown", false)
					--end)
				end
				
			end
		end
		return 1

	end,
	
	onAnyKill = function(self, Unit: Model, Killer: Model, Enemy: {any}?)
		
		local PassiveStacks = Unit:GetAttribute("PassiveStacks") or 0
		if Enemy then
			if Enemy.IsBoss then
				Unit:SetAttribute("PassiveStacks", 0)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-(PassiveStacks))
			end
		end
		
	end,

}

return Passive
