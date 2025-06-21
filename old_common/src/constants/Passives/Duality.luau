local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Duality",
	PassiveDescription = "Having multiple Ihigos in range will buff all of them by 5%",
	BuffPercent = 0.05
} 

local function apply(unit, amount)
	unit:SetAttribute("PermanentAttackSpeedMulti", unit:GetAttribute("PermanentAttackSpeedMulti") - amount)
	unit:SetAttribute("PermanentDamageMulti", unit:GetAttribute("PermanentDamageMulti") + amount)
	unit:SetAttribute("PermanentRangeMulti", unit:GetAttribute("PermanentRangeMulti") + amount)
end

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		local BuffUnits = {}

		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange and string.match(UnitToCheck.Name, "Ichigo") then
				table.insert(BuffUnits, UnitToCheck)
			end
		end

		if #BuffUnits >= 1 and not Unit:GetAttribute("DualityBuff") then
			Unit:SetAttribute("DualityBuff", true)
			apply(Unit, Passive.configuration.BuffPercent)

			for _, UnitToBuff in BuffUnits do
				if not UnitToBuff:GetAttribute("DualityBuff") then
					UnitToBuff:SetAttribute("DualityBuff", true)
					UnitToBuff:SetAttribute("DualityBuffID", UnitIndividualID)
					apply(UnitToBuff, Passive.configuration.BuffPercent)
				end
			end

			return
		end

		if #BuffUnits < 1 and Unit:GetAttribute("DualityBuff") then
			Unit:SetAttribute("DualityBuff", false)
			apply(Unit, -Passive.configuration.BuffPercent)

			for _, UnitToBuff in BuffUnits do
				if UnitToBuff:GetAttribute("DualityBuff") then
					UnitToBuff:SetAttribute("DualityBuff", nil)
					UnitToBuff:SetAttribute("DualityBuffID", nil)
					apply(UnitToBuff, -Passive.configuration.BuffPercent)
				end
			end
		end
	end,
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("DualityBuff") == true and UnitToCheck:GetAttribute("DualityBuffID") == UnitIndividualId then
				UnitToCheck:SetAttribute("DualityBuff", nil)
				UnitToCheck:SetAttribute("DualityBuffID", nil)
				apply(UnitToCheck, -Passive.configuration.BuffPercent)
			end
		end
	end,
}

return Passive
