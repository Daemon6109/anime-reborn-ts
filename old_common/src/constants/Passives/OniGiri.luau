local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "OniGiri",
	PassiveDescription = "This unit does 2x scar DoT damage to shielded & boss enemies.",
	PercentIncrease = 2,
	StatusNeeded = "Scar",	
} 

Passive.callbacks = {
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		
		--warn("Enemy", Enemy, Enemy.ShieldCharges)
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects and (Enemy.ShieldCharges or Enemy.IsBoss) then
			local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true
			if HasStatus then
				return Passive.configuration.PercentIncrease
			end
		end

		return 1
		
	end,
	
}

return Passive
