local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Mr. President",
	PassiveDescription = "After defeating 23 enemies, Smiling Valentine’s next attack envelops him and allied units within range in a barrier for 15 seconds. This barrier makes them immune to negative effects.",
	TagName = "MrPresident",
	MaxPassiveStacks = 23,
	Duration = 15,
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local CurrentStacks = Unit:GetAttribute(`{Passive.configuration.TagName}Stacks`) or 0
		
		if CurrentStacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute(`{Passive.configuration.TagName}Stacks`, CurrentStacks+1)
		end
	end,
	
	onAttack = function(self, Unit: Model)
		local CurrentStacks = Unit:GetAttribute(`{Passive.configuration.TagName}Stacks`) or 0
		
		if CurrentStacks >= Passive.configuration.MaxPassiveStacks then
			local Allies = _G.UnitHandler:GetAllyUnitsInRange(Unit)
			
			Unit:RemoveTag("Stunned")
			Unit:AddTag("NonTarget")
			Unit:AddTag("NoStun")
			Unit:AddTag(Passive.configuration.TagName)
			
			for _, Ally in Allies do
				Ally:RemoveTag("Stunned")
				Ally:AddTag("NonTarget")
				Ally:AddTag("NoStun")
				Ally:AddTag(Passive.configuration.TagName)
			end
			
			task.delay(Passive.configuration.Duration / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute(`{Passive.configuration.TagName}Stacks`, 0)
				
				Unit:RemoveTag("NonTarget")
				Unit:RemoveTag("NoStun")
				Unit:RemoveTag(Passive.configuration.TagName)
				
				for _, Ally in Allies do
					Ally:RemoveTag("NonTarget")
					Ally:RemoveTag("NoStun")
					Ally:RemoveTag(Passive.configuration.TagName)
				end
			end)
		end
	end,
}

return Passive
