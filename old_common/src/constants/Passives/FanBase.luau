local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Fanbase",
	PassiveDescription = "Mr. set gains 1% damage per unit in his range (max. 10%)",
	MaxPassiveStacks = 10,
	PercentPerStack = 0.01,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()

		if not Unit:GetAttribute("FanbaseStacks") then
			Unit:SetAttribute("FanbaseStacks", 0)
		end

		local InRangeCount = 0

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local CurrentFanbaseStacks = Unit:GetAttribute("FanbaseStacks")

			if FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange and InRangeCount < Passive.configuration.MaxPassiveStacks then
				InRangeCount += 1
			end
		end

		local CurrentFanbaseStacks = Unit:GetAttribute("FanbaseStacks")
		local Difference = (InRangeCount-CurrentFanbaseStacks)
		Unit:SetAttribute("FanbaseStacks", CurrentFanbaseStacks+Difference)

		local CurrentMultiDMG = Unit:GetAttribute("PermanentDamageMulti")

		Unit:SetAttribute("PermanentDamageMulti", CurrentMultiDMG+(Passive.configuration.PercentPerStack*Difference))
	end,
}

return Passive
