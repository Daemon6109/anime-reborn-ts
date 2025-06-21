local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Cien Fleur Bind",
	PassiveDescription = "Every 15th attack, Robin summons a tornado that stuns all enemies hit for 2.5 seconds. During the stun, enemies take 15% more damage.",
}

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		Unit:SetAttribute("PassiveStun", false)

		if math.random(1, 4) == 1 then
			Unit:SetAttribute("PassiveStun", true)
		end
	end,
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Enemy.StatusEffects["Stun"] == true

			if HasStatus then
				return 1.15
			end
		end

		return 1
	end,
}

return Passive
