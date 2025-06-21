local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Together we shine",
	PassiveDescription = "First 10 units within Twenty One's range get +15% range increase",
	PercentIncrease = .15,
	MaxPassiveStacks = 10,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local CurrentStacksInitial = Unit:GetAttribute("TogetherWeShineStacks") or 0
		local BuffedCountCheck = 0
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck:GetAttribute("TogetherWeShineId") == UnitIndividualID then
				BuffedCountCheck += 1
			end
		end
		
		if CurrentStacksInitial ~= BuffedCountCheck then
			Unit:SetAttribute("TogetherWeShineStacks", CurrentStacksInitial+(BuffedCountCheck-CurrentStacksInitial))
		end
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			local BuffDiff = Passive.configuration.PercentIncrease 
			local HasBuff = UnitToCheck:GetAttribute("TogetherWeShineBuff")
			local CurrentStacks = Unit:GetAttribute("TogetherWeShineStacks") or 0
			
			if not HasBuff and IsInRange and CurrentStacks < Passive.configuration.MaxPassiveStacks then
				Unit:SetAttribute("TogetherWeShineStacks", CurrentStacks+1)
				UnitToCheck:SetAttribute("TogetherWeShineBuff", IsInRange)
				UnitToCheck:SetAttribute("TogetherWeShineId", Unit:GetAttribute("IUUID"))
				UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")+BuffDiff)
			end
		end
	end,
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")
		
		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("TogetherWeShineBuff") == true and UnitToCheck:GetAttribute("TogetherWeShineId") == UnitIndividualId then
				UnitToCheck:SetAttribute("TogetherWeShineBuff", false)
				UnitToCheck:SetAttribute("TogetherWeShineId", nil)
				UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")-Passive.configuration.PercentIncrease)
			end
		end
	end,
}

return Passive
