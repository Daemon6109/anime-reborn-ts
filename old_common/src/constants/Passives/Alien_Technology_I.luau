local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Alien Technology I",
	--PassiveDescription = "All units in range get -10% SPA buff.",
	PassiveDescription = "Does 90% more damage to heavy foes.", --"This unit buffs 3 random unit in his radius damage by 25% for 10 seconds every 30 seconds",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag("HeavyStrong")
	end,
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		local BuffLib = require(replicated.Libs.BuffLib)
		if Enemy and Enemy.Health > 0 and (Enemy.Class == "Shield" or Enemy.Class == "Guardian") then
			return 1.9
		end

		return 1
	end,
}

return Passive
