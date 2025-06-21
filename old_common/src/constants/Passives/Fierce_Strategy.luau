local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Fierce Strategy",
	PassiveDescription = "If there is more than 3 units of the same element in his range this unit gains 15% dmg and 10% range if there is less than 3 units of the same element in his range this unit gains 25% crit chance and 30% crit dmg ( does not stack )",
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
					table.insert(BuffedUnits, UnitToCheck)
				end
			end
		end

		if #BuffedUnits >= 3 and not Unit:GetAttribute("FierceStrategy") then
			Unit:SetAttribute("FierceStrategy", true)
			Unit:SetAttribute("PermanentDamageMulti", (Unit:GetAttribute("PermanentDamageMulti") or 0) + 0.15)
			Unit:SetAttribute("PermanentRangeMulti", (Unit:GetAttribute("PermanentRangeMulti") or 0) + 0.1)
		elseif #BuffedUnits < 3 and Unit:GetAttribute("FierceStrategy") then
			Unit:SetAttribute("FierceStrategy", false)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti") - 0.15)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti") - 0.1)
		end

		if #BuffedUnits < 3 and not Unit:GetAttribute("FierceStrategy2") then
			Unit:SetAttribute("FierceStrategy2", true)
			Unit:SetAttribute("PermanentAttackCriticalDamage", (Unit:GetAttribute("PermanentAttackCriticalDamage") or 0) + 0.3)
			Unit:SetAttribute("PermanentAttackCriticalChance", (Unit:GetAttribute("PermanentAttackCriticalChance") or 0) + 0.25)
		elseif #BuffedUnits >= 3 and Unit:GetAttribute("FierceStrategy2") then
			Unit:SetAttribute("FierceStrategy2", false)
			Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage") - 0.3)
			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance") - 0.25)
		end
	end,

	onRemove = function(self, Unit: Model)
		return
			--local UnitIndividualId = Unit:GetAttribute("IUUID")

			--for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			--	if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
			--		continue
			--	end

			--	if UnitToCheck:GetAttribute("FierceDarknessBuff") == true and UnitToCheck:GetAttribute("FierceDarknessId") == UnitIndividualId then
			--		UnitToCheck:SetAttribute("FierceDarknessBuff", false)
			--		UnitToCheck:SetAttribute("FierceDarknessId", nil)
			--		UnitToCheck:SetAttribute("PermanentDmgToBossMulti", UnitToCheck:GetAttribute("PermanentDmgToBossMulti")-0.15) 
			--	end
			--end
	end,

}

return Passive
