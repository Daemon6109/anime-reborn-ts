local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Flame Fruit",
	PassiveDescription = "Mage Inflicts burn equal to 100% of his damage.",
	PercentIncrease = 2,
	StatusNeeded = "Burning"
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
