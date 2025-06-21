local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Shared Misery",
	PassiveDescription = "First 5 units within Pikkora's range get +15% boss damage increase",
	PercentIncrease = .15,
	MaxPassiveStacks = 5,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local CurrentStacksInitial = Unit:GetAttribute("SharedMiseryStacks") or 0
		local BuffedCountCheck = 0
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck:GetAttribute("SharedMiseryId") == UnitIndividualID then
				BuffedCountCheck += 1
			end
		end
		
		if CurrentStacksInitial ~= BuffedCountCheck then
			Unit:SetAttribute("SharedMiseryStacks", CurrentStacksInitial+(BuffedCountCheck-CurrentStacksInitial))
		end
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			local BuffDiff = Passive.configuration.PercentIncrease 
			local HasBuff = UnitToCheck:GetAttribute("SharedMiseryBuff")
			local CurrentStacks = Unit:GetAttribute("SharedMiseryStacks") or 0
			
			if not HasBuff and IsInRange and CurrentStacks < Passive.configuration.MaxPassiveStacks then
				Unit:SetAttribute("SharedMiseryStacks", CurrentStacks+1)
				UnitToCheck:SetAttribute("SharedMiseryBuff", IsInRange)
				UnitToCheck:SetAttribute("SharedMiseryId", Unit:GetAttribute("IUUID"))
				UnitToCheck:SetAttribute("PermanentDmgToBossMulti", UnitToCheck:GetAttribute("PermanentDmgToBossMulti")+BuffDiff)
			end
		end
	end,
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")
		
		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("SharedMiseryBuff") == true and UnitToCheck:GetAttribute("SharedMiseryId") == UnitIndividualId then
				UnitToCheck:SetAttribute("SharedMiseryBuff", false)
				UnitToCheck:SetAttribute("SharedMiseryId", nil)
				UnitToCheck:SetAttribute("PermanentDmgToBossMulti", UnitToCheck:GetAttribute("PermanentDmgToBossMulti")-Passive.configuration.PercentIncrease)
			end
		end
	end,
}

return Passive
