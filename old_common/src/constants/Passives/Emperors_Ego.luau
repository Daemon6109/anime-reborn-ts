local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Emperors Ego",
	PassiveDescription = "If unit is the highest starting cost unit in his range, Every wave gain 1% damage and 0.5% range upto 10% damage and 5% range, at max stacks gain 15% critical chance.",
} 

Passive.callbacks = {
	
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		
		local HighestCost = 0;		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			if IsInRange then
				if UnitToCheck.configuration.PlacementPrice.Value > HighestCost then
					HighestCost = UnitToCheck.configuration.PlacementPrice.Value
				end
			end
		end
		
		if HighestCost < 2500 and HighestCost > 0 then
			Unit:SetAttribute("HighestCost", true)
		else
			Unit:SetAttribute("HighestCost", false)
		end
		
	end,
	
	onRemove = function(self, Unit: Model)

	end,
	
	onWave = function(self, Unit: Model)
		
		local HighestCost = Unit:GetAttribute("HighestCost") or false
		local Stacks = Unit:GetAttribute("FStacks") or 0
		
		if HighestCost then
			
			if Stacks < 10 then
				Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.005)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.01)
			elseif Stacks == 10 then
				Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+0.15)
			end
			Unit:SetAttribute("FStacks", Stacks + 1)
		end
		
	end,
	
}

return Passive
