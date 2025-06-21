local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Double Face",
	PassiveDescription = "On every attack, has 25% chance to do 50% more damage.",
}

Passive.callbacks = {

	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if math.random(1, 100) < 25 then
			return 1.5
		end
		return 1
	end,
}

return Passive
