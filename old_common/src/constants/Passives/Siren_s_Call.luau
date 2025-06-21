local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Siren's Call",
	PassiveDescription = "+10% range buff for every unit in range (Non-stackable)",
	PercentIncrease = .1,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			local BuffDiff = IsInRange and Passive.configuration.PercentIncrease or -Passive.configuration.PercentIncrease 
			local HasBuff = UnitToCheck:GetAttribute("SirensCallBuff")
			
			if not HasBuff and IsInRange then
				UnitToCheck:SetAttribute("SirensCallBuff", IsInRange)
				UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")+BuffDiff)
			end
		end
	end,
	onRemove = function(self, Unit: Model)
		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("SirensCallBuff") == true then
				UnitToCheck:SetAttribute("SirensCallBuff", false)
				UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")-Passive.configuration.PercentIncrease )
			end
		end
	end,
}

return Passive
