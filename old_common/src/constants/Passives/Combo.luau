local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Combo",
	PassiveDescription = "Deals +5% damage with each consecutive attack on an enemy (up to +20%).",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 then
			local Stack = Enemy.SaberStacks or 0
			
			if Stack < 4 then
				Enemy.SaberStacks = Stack + 1
			end

			return 1+(Stack * .05)
		end

		return 1
	end,
}

return Passive
