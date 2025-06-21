local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Spiritual Power",
	PassiveDescription = "This unit has 25% chance to slow down the enemies",
	--ProcChance = 25,
}

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		Unit:SetAttribute("PassiveSlow", false)
		
		if math.random(1, 4) == 1 then
			Unit:SetAttribute("PassiveSlow", true)
		end
	end,
}

return Passive
