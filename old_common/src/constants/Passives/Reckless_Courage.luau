local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Reckless Courage",
	PassiveDescription = "If no allies in range, Unit can not be stunned.",
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local BuffAmount = Unit:GetAttribute("BBYBuffIncrease") or 0
		local LastBuffAmount = Unit:GetAttribute("BBVYBuffIncrease") or 0
		
		local BuffedUnits = {};

		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange then
				table.insert(BuffedUnits, UnitToCheck)
			end
		end
		
		if #BuffedUnits >= 1 then
			Unit:AddTag("InnateNoStun")
		else
			Unit:RemoveTag("InnateNoStun")
		end
		
	end,
	
	onRemove = function(self, Unit: Model)
		
	end,
}

return Passive
