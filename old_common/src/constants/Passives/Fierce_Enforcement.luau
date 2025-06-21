local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Fierce Enforcement",
	PassiveDescription = "For every fierce unit in his range he gains 20% dmg against boss enemies up to 100% dmg, while fierce units in his range, they gain 15% dmg against boss enemies.",
} 

Passive.callbacks = {

	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		local BuffAmount = Unit:GetAttribute("FierceBuffIncrease") or 0
		local LastBuffAmount = Unit:GetAttribute("FierceBuffIncrease2") or 0

		local BuffedUnits = {};

		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			--and UnitToCheck.configuration.Element.Value == Passive.configuration.TargetElement
			if IsInRange then
				print("here assistant")
				if UnitToCheck.configuration.Element.Value == "Fierce" then
					if not UnitToCheck:GetAttribute("FierceDarknessBuff") then
						UnitToCheck:SetAttribute("FierceDarknessId", UnitIndividualID)
						UnitToCheck:SetAttribute("FierceDarknessBuff", true)
						UnitToCheck:SetAttribute("PermanentDmgToBossMulti", UnitToCheck:GetAttribute("PermanentDmgToBossMulti")+0.15) 
					end
					table.insert(BuffedUnits, UnitToCheck)
				end
			end
		end

		if #BuffedUnits >= 5 then
			Unit:SetAttribute("FierceBuffIncrease", 50)
		else
			Unit:SetAttribute("FierceBuffIncrease", (#BuffedUnits)*10)
		end

		warn("#buff", #BuffedUnits)

		BuffAmount = Unit:GetAttribute("FierceBuffIncrease")
		if LastBuffAmount < BuffAmount then
			local Amount = BuffAmount - LastBuffAmount
			Unit:SetAttribute("PermanentDmgToBossMulti", Unit:GetAttribute("PermanentDmgToBossMulti")+Amount*2/100)
		elseif LastBuffAmount > BuffAmount then
			local Amount = LastBuffAmount - BuffAmount
			Unit:SetAttribute("PermanentDmgToBossMulti", Unit:GetAttribute("PermanentDmgToBossMulti")-Amount*2/100)
		end
		Unit:SetAttribute("FierceBuffIncrease2", BuffAmount)

	end,

	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("FierceDarknessBuff") == true and UnitToCheck:GetAttribute("FierceDarknessId") == UnitIndividualId then
				UnitToCheck:SetAttribute("FierceDarknessBuff", false)
				UnitToCheck:SetAttribute("FierceDarknessId", nil)
				UnitToCheck:SetAttribute("PermanentDmgToBossMulti", UnitToCheck:GetAttribute("PermanentDmgToBossMulti")-0.15) 
			end
		end
	end,

}

return Passive
