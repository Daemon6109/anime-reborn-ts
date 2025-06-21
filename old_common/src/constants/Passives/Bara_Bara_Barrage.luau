local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Bara Bara Barrage",
	PassiveDescription = "Unit applies `Scar` on each attack. `Scar` enemies takes 7.5% more damage.",
}

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Enemy.StatusEffects["Scar"] == true

			if HasStatus then
				return 1.075
			end
		end

		return 1
	end,
}

return Passive
