local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Soul Echoes",
	PassiveDescription = "Enemies that has lower than 30% health, attacked for the first time, will get `Frozen` for 2s.",
}

Passive.callbacks = {
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.Health <= Enemy.MaxHealth*.30 then
			local Stack = Enemy.SoulStacks or 0
			if Stack == 0 then
				Enemy.SoulStacks = 1
				_G.Registry.registry.StatusEffects.Frozen:OnServer(Unit, {Enemy}, 2)
			end
			return 1
		end

		return 1
	end,
	
}

return Passive
