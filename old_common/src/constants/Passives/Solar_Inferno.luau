local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Solar Inferno",
	PassiveDescription = "All allies in range get increased DoT dmg by 30% and for each fire element unit in range gain 15% increased DoT dmg up to 75%.",
	TargetElement = "Fire",
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local BuffAmount = Unit:GetAttribute("YBuffIncrease") or 0
		local LastBuffAmount = Unit:GetAttribute("VYBuffIncrease") or 0

		local BuffedUnits = {};

		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange then
				if not UnitToCheck:GetAttribute("VYBuff") then
					UnitToCheck:SetAttribute("YBuffID", UnitIndividualID)
					UnitToCheck:SetAttribute("YBuff", true)
					UnitToCheck.configuration.AttackEffectDamageMultiplier.Value += 0.3
				end
				if UnitToCheck.configuration.Element.Value == Passive.configuration.TargetElement then
					table.insert(BuffedUnits, UnitToCheck)
				end
			end
		end

		if #BuffedUnits >= 5 then
			Unit:SetAttribute("YBuffIncrease", 75)
		else
			Unit:SetAttribute("YBuffIncrease", (#BuffedUnits)*15)
		end

		BuffAmount = Unit:GetAttribute("YBuffIncrease")
		if LastBuffAmount < BuffAmount then
			local Amount = BuffAmount - LastBuffAmount
			Unit.configuration.AttackEffectDamageMultiplier.Value += Amount/100
		elseif LastBuffAmount > BuffAmount then
			local Amount = LastBuffAmount - BuffAmount
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-Amount/100)
			Unit.configuration.AttackEffectDamageMultiplier.Value -= Amount/100
		end
		Unit:SetAttribute("YBuffIncrease", BuffAmount)
	end,

	onRemove = function(self, Unit: Model)

		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		for _, UnitToCheck in CurrentlyPlaced do

			if not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("YBuffID") == UnitIndividualID then
				UnitToCheck:SetAttribute("YBuffID", nil)
				UnitToCheck:SetAttribute("YBuff", false)
				UnitToCheck.configuration.AttackEffectDamageMultiplier.Value -= 0.3
			end
		end

	end,
}

return Passive
