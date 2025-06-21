local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "On Point",
	PassiveDescription = "This unit has 35% chance to do double damage",
	PercentIncrease = 2,
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and math.random(1,100) <= 35 then
			return Passive.configuration.PercentIncrease
		end
		
		return 1
	end,
}

return Passive
