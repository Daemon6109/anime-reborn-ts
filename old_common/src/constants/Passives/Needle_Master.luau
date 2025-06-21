local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Needle Master",
	PassiveDescription = "If an enemy has lower than 20% hp, deals 15% increased dmg against them and his chance to leave a needle is increased by 10%",
	StatusNeeded = "Burning"
}

Passive.callbacks = {

	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects and Enemy.Health < Enemy.MaxHealth*.20 then
			if math.random(1, 100) < 10 then
				Enemy["NeedleHas"] = true
			end
			return 1.15
		end
		return 1
	end,
}

return Passive
