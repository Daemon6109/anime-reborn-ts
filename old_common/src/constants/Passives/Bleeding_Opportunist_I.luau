local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Scarring Opportunist I",
	PassiveDescription = "+100% crit chance against `Scar` enemies",
	StatusNeeded = "Scar",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)
			
			if HasStatus then
				return 1, true
			end
		end
		
		return 1
	end,
}

return Passive
