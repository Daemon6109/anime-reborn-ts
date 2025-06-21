local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Shared Sight",
	PassiveDescription = "This unit gives first 2 units in radius the ability to see 'Shade' type enemies",
} 

Passive.callbacks = {
	--onPlace = function(self, Unit: Model)
	--	Unit:AddTag("TrueSight")
	--end,
	
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()

		local Amount = Unit:GetAttribute("SharedSightStack") or 0

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			local BuffDiff = IsInRange and Passive.configuration.PercentIncrease or -Passive.configuration.PercentIncrease 
			local HasBuff = UnitToCheck:GetAttribute("SharedSight")

			if not HasBuff and IsInRange and Amount <= 2 then
				Amount += 1
				Unit:SetAttribute("SharedSightStack", Amount)
				UnitToCheck:AddTag("TrueSight")
				UnitToCheck:SetAttribute("SharedSight", true)
			end
		end
	end,

	onRemove = function(self, Unit: Model)
		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("SharedSight") == true then
				UnitToCheck:SetAttribute("SharedSight", false)
				UnitToCheck:RemoveTag("TrueSight")
			end
		end
	end,
}

return Passive
