local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Mist Cover",
	PassiveDescription = "Every time this unit is stunned, damage +2.5% (Up to 35%). Additionally +15% DMG to bosses. ",
	
	PercentPerStack = 0.025,
	MaxPassiveStacks = 14
} 

Passive.callbacks = {
	onStunned = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("MistStacks")

		if Stacks or 0 < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("MistStacks", Stacks+1)

			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease)
		end
	end,
	
	onPlace = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)

		if config then
			Unit:SetAttribute("PermanentDmgToBossMulti", Unit:GetAttribute("PermanentDmgToBossMulti")+.15) 
		end
	end,
}

return Passive