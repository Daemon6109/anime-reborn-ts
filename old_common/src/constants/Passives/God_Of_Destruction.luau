local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "God Of Destruction",
	PassiveDescription = "Has a 30% chance to insta-kill enemies below 15% HP",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		local BuffLib = require(replicated.Libs.BuffLib)
		if Enemy and Enemy.Health > 0 then
			local Chance = Random.new():NextNumber(0, 100)

			if Chance <= 30 then
				if Enemy.Health <= (Enemy.MaxHealth * 0.15) then
					return 1+(Enemy.Health/BuffLib:GetDamage(Unit))
				end
			end
		end
		
		return 1
	end,
}

return Passive
