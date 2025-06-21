local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Blindness",
	PassiveDescription = "Immune to debuffs but has 5% to miss an attack",
} 

Passive.callbacks = {
	
	onPlace = function(self, Unit: Model)
		Unit:AddTag("InnateNonTarget")
		Unit:AddTag("InnateNoStun")
	end,

	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		
		if math.random(1, 5) <= 1 then
			return 0
		end
		return 1
		
	end,

}

return Passive
