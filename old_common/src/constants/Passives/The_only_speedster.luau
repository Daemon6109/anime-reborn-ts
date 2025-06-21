local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "The Only Speedster",
	PassiveDescription = "100% increased damage to speedsters",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag("SpeedsterStrong")
	end,
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.Class then
			local IsClass = Enemy.Class == "Speedster"

			if IsClass then
				return 2
			end
		end

		return 1
	end,
}

return Passive
