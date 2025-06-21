local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Two Steps Ahead",
	PassiveDescription = "30% chance to stun enemies for 7.5s, and deals +275% damage to bosses if they are stunned",
	StatusNeeded = "Stun",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local StatusEffect = _G.Registry.registry.StatusEffects["Stun"]
			local Chance = Random.new():NextNumber(0, 100)

			if Chance <= 30 then
				StatusEffect:OnServer(Unit, {Enemy}, 7.5)
			end
			
			local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)
			
			if HasStatus and Enemy.IsBoss then
				return 3.75
			end
		end
		
		return 1
	end,
}

return Passive
