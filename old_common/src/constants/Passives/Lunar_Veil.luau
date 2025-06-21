local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Lunar Veil",
	PassiveDescription = "Water units in range gains 10% Damage and 15% range. For every water unit in range, gain 2% dmg upto 10%.",
	TargetElement = "Water",
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local BuffAmount = Unit:GetAttribute("VYBuffIncrease") or 0
		local LastBuffAmount = Unit:GetAttribute("LVYBuffIncrease") or 0
		
		local BuffedUnits = {};

		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange and UnitToCheck.configuration.Element.Value == Passive.configuration.TargetElement then
				if not UnitToCheck:GetAttribute("VYBuff") then
					UnitToCheck:SetAttribute("VYBuffID", UnitIndividualID)
					UnitToCheck:SetAttribute("VYBuff", true)
					UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")+0.1)
					UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")+0.15) 
				end
				table.insert(BuffedUnits, UnitToCheck)
			end
		end
		
		if #BuffedUnits >= 5 then
			Unit:SetAttribute("VYBuffIncrease", 10)
		else
			Unit:SetAttribute("VYBuffIncrease", (#BuffedUnits)*2)
		end
		
		BuffAmount = Unit:GetAttribute("VYBuffIncrease")
		if LastBuffAmount < BuffAmount then
			local Amount = BuffAmount - LastBuffAmount
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Amount/100)
		elseif LastBuffAmount > BuffAmount then
			local Amount = LastBuffAmount - BuffAmount
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-Amount/100)
		end
		Unit:SetAttribute("LVYBuffIncrease", BuffAmount)
	end,
	
	onRemove = function(self, Unit: Model)
		
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		for _, UnitToCheck in CurrentlyPlaced do
			
			if not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("VYBuffID") == UnitIndividualID then
				UnitToCheck:SetAttribute("VYBuffID", nil)
				UnitToCheck:SetAttribute("VYBuff", false)
				UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")-0.1)
				UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")-0.15) 
			end
		end
		
	end,
}

return Passive
