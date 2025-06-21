local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Gravity Force II",
	PassiveDescription = "Stuns enemies on every 4th attack.",
	MaxPassiveStacks = 4,
	--ProcChance = 25,
}

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("GravityForceStacks") or 0
		Unit:SetAttribute("PassiveStun", false)
		Unit:SetAttribute("GravityForceStacks", Stacks+1)
		
		if Unit:GetAttribute("GravityForceStacks") == Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("GravityForceStacks", 0)
			Unit:SetAttribute("PassiveStun", true)
			return
		end
	end,
}

return Passive
