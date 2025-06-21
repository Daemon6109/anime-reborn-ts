local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Shunko",
	PassiveDescription = "Enemies attacked for the first time will take 10% more damage while being stunned for 2s",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 then
			local Stack = Enemy.ShunkoStacks or 0
			
			if Stack == 0 then
				Enemy.ShunkoStacks = 1
				_G.Registry.registry.StatusEffects.Stun:OnServer(Unit, {Enemy}, 2)
			end

			return 1.1
		end

		return 1
	end,
}

return Passive
