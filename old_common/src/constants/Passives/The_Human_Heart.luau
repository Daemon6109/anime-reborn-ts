local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "The Human Heart",
	PassiveDescription = "Light units in his range gain 15% dmg and 10% critical chance and for each light unit in his range he gains 4% dmg up to 16% and 12% critical chance.",
	TargetElement = "Light",
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

			if IsInRange and UnitToCheck.configuration.Element.Value == Passive.configuration.TargetElement then
				if not UnitToCheck:GetAttribute("BBYBuff") then
					UnitToCheck:SetAttribute("BBYBuffID", UnitIndividualID)
					UnitToCheck:SetAttribute("BBYBuff", true)
					UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")+0.15)
					UnitToCheck:SetAttribute("PermanentAttackCriticalChance", UnitToCheck:GetAttribute("PermanentAttackCriticalChance")+0.1) 
				end
				table.insert(BuffedUnits, UnitToCheck)
			end
		end
		
		if #BuffedUnits <= 4 then
			Unit:SetAttribute("BBYBuffIncrease", (#BuffedUnits))
		end
		
		BuffAmount = Unit:GetAttribute("BBYBuffIncrease")
		if LastBuffAmount < BuffAmount then
			local Amount = BuffAmount - LastBuffAmount
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+(Amount/100)*4)
			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+(Amount/100)*3)
		elseif LastBuffAmount > BuffAmount then
			local Amount = LastBuffAmount - BuffAmount
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-(Amount/100) * 4)
			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")-(Amount/100)*3)
		end
		
		Unit:SetAttribute("BBVYBuffIncrease", BuffAmount)
		
	end,
	
	onRemove = function(self, Unit: Model)
		
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		for _, UnitToCheck in CurrentlyPlaced do
			
			if not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("BBYBuffID") == UnitIndividualID then
				UnitToCheck:SetAttribute("BBYBuffID", nil)
				UnitToCheck:SetAttribute("BBYBuff", false)
				UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")-0.15)
				UnitToCheck:SetAttribute("PermanentAttackCriticalChance", UnitToCheck:GetAttribute("PermanentAttackCriticalChance")-0.1) 
			end
		end
		
	end,
}

return Passive
