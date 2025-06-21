local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Freezing Aura",
	PassiveDescription = "Attacks freeze enemies that are below 40% health",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0  then
			
			if Enemy.Health < Enemy.MaxHealth*.4 then
				local StatusEffect = _G.Registry.registry.StatusEffects["Frozen"] 

				if StatusEffect then
					StatusEffect:OnServer(Unit, {Enemy}, 3)
				end
				
				return 1
			end
			--local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)
			
			--if HasStatus then
			--	return Passive.configuration.PercentIncrease
			--end
		end
		
		return 1
	end,
}

return Passive
