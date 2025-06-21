local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Pinpoint Strikes",
	PassiveDescription = "Does +35% more damage to enemies under `Scar` status effect.",
	PercentIncrease = 1.35,
	StatusNeeded = "Scar",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)
			
			if HasStatus then
				return Passive.configuration.PercentIncrease
			end
		end
		
		return 1
	end,
}

return Passive
