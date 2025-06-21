local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Psychic Surge",
	--PassiveDescription = "All units in range get -10% SPA buff.",
	PassiveDescription = "Mimi deals 30% more damage to bosses.", --"This unit buffs 3 random unit in his radius damage by 25% for 10 seconds every 30 seconds",
	
	BuffData = {
		Damage = .25, -- %s
	},
	Duration = 10
	
	--PercentIncrease = .1,
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		local BuffLib = require(replicated.Libs.BuffLib)
		if Enemy and Enemy.Health > 0 and Enemy.Class ~= "Regular" then
			return 1.3
		end

		return 1
	end,
}

return Passive
