local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Bandit’s Secret",
	PassiveDescription = "For every unit in his range Chrollo gains +3% Damage up to 15%, but if there is more than 5 units in his range he loses the buff.",
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local BuffAmount = Unit:GetAttribute("gYBuffIncrease") or 0
		local LastBuffAmount = Unit:GetAttribute("GVYBuffIncrease") or 0
		
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
		
		if #BuffedUnits <= 5 then

			Unit:SetAttribute("gYBuffIncrease", (#BuffedUnits)*3)
			BuffAmount = Unit:GetAttribute("gYBuffIncrease")
			if LastBuffAmount < BuffAmount then
				local Amount = BuffAmount - LastBuffAmount
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Amount/100)
			elseif LastBuffAmount > BuffAmount then
				local Amount = LastBuffAmount - BuffAmount
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-Amount/100)
			end
			Unit:SetAttribute("GVYBuffIncrease", BuffAmount)
		elseif #BuffedUnits > 5 then
			Unit:SetAttribute("gYBuffIncrease", 0)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-LastBuffAmount/100)
			Unit:SetAttribute("GVYBuffIncrease", 0)
		end
	end,
	
	onRemove = function(self, Unit: Model)
		
	end,
}

return Passive
