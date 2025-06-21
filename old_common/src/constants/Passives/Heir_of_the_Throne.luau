local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Heir of the Throne",
	PassiveDescription = "When placed, units in her range are considered her `Rook Pieces`, whenever a rook attacks, Rise's Damage is increased by 1% (Upto 50%)",
	TagName = "RiasRook",
	MaxPassiveStacks = 50,
	PercentPerStack = 0.01,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local Allies = _G.UnitHandler:GetAllyUnitsInRange(Unit)
		local IUUID = Unit:GetAttribute("IUUID")
		
		for _, Ally: Model in Allies do
			if not Ally:HasTag(Passive.configuration.TagName) then
				Ally:SetAttribute(`{Passive.configuration.TagName}Id`, Unit:GetAttribute("IUUID"))
				Ally:AddTag(Passive.configuration.TagName)
			end
		end
	end,
	
	onRemove = function(self, Unit: Model)
		local IUUID = Unit:GetAttribute("IUUID")
		
		for _, Ally in workspace.UnitsPlaced:GetChildren() do
			if Ally:HasTag(Passive.configuration.TagName) and Ally:GetAttribute(`{Passive.configuration.TagName}Id`) == IUUID then
				Ally:SetAttribute(`{Passive.configuration.TagName}Id`, nil)
				Ally:RemoveTag(Passive.configuration.TagName)
			end
		end
	end,
	
	onAllyAttack = function(self, Unit: Model, Ally: Model)
		if Ally:HasTag(Passive.configuration.TagName) and Ally:GetAttribute(`{Passive.configuration.TagName}Id`) == Unit:GetAttribute("IUUID") then
			local Stacks = Unit:GetAttribute(`{Passive.configuration.TagName}Stacks`) or 0
			
			if Stacks < Passive.configuration.MaxPassiveStacks then
				Unit:SetAttribute(`{Passive.configuration.TagName}Stacks`, Stacks+1)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentPerStack)
			end
		end
	end,
}

return Passive
