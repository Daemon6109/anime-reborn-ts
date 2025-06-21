local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Finishing Blow",
	PassiveDescription = "Deals 30% more DMG to enemies below 25% HP.",
	PercentIncrease = 1.3,
	StatusNeeded = "Scar",
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.Health <= Enemy.MaxHealth*.25 then
			
			--warn("DID MORE DMG")
			return Passive.configuration.PercentIncrease
		end
		
		return 1
	end,
}

return Passive
