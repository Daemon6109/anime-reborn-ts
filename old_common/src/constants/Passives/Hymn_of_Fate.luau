local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Hymn of Fate",
	PassiveDescription = "Tusk randomly burns, slows or stuns the units hit by his attacks.",
	StatusEffects = {
		[1] = {
			Name = "Burning",
			Duration = 3
		},
		[2] = {
			Name = "Slow",
			Duration = 2
		},
		[3] = {
			Name = "Stun",
			Duration = 1
		}
	}
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		
		if config then
			local statusEffect = Passive.configuration.StatusEffects[math.random(1, #Passive.configuration.StatusEffects)]

			config.AttackEffect.Value = statusEffect.Name
			config.AttackEffectDuration.Value = statusEffect.Duration
		end
	end,
}

return Passive
