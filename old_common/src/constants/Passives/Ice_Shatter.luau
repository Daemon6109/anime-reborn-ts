local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Ice Shatter",
	PassiveDescription = "Does +25% more damage to enemies under `Frozen` status effect and deals 15% damage each second for 5 seconds.",
	PercentIncrease = 1.25,
	StatusNeeded = "Frozen",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)
			
			if HasStatus then
				local StatusEffect = _G.Registry.registry.StatusEffects["Ice Shatter"] 

				if StatusEffect then
					StatusEffect:OnServer(Unit, {Enemy}, 5)
				end
				
				return Passive.configuration.PercentIncrease
			end
		end
		
		return 1
	end,
}

return Passive
