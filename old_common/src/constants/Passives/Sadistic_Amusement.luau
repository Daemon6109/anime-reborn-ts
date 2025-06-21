local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Sadistic Amusement",
	PassiveDescription = "Unit deals 10% more damage against enemies below 75% hp and 15% more dmg against enemies below 50% hp.",
	StatusNeeded = "Burning"
}

Passive.callbacks = {
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 then
			if Enemy.Health < Enemy.MaxHealth*.75 then
				return 1.1
			elseif Enemy.Health < Enemy.MaxHealth*.50 then
				return 1.15
			end
		end
		return 1
	end,
}

return Passive
