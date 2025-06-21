local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Family Influence",
	PassiveDescription = "Whenever Laughfy is placed in Mage’s range, he gains +25% Damage and +10% Range."
} 

Passive.callbacks = {
	
	onUnitsInRange = function(self, Unit: Model)
		
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitIndividualID = Unit:GetAttribute("IUUID")

		local BuffUnits = {}

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange then
				if (string.match(UnitToCheck.Name, "Luffy") or UnitToCheck.Name == "Luffy [DR] [Evo]" or UnitToCheck.Name == "Luffy [DR]") then
					table.insert(BuffUnits, UnitToCheck)
				end
			end
		end

		if not Unit:GetAttribute("OriginalDamageMulti") then
			Unit:SetAttribute("OriginalDamageMulti", Unit:GetAttribute("PermanentDamageMulti"))
		end

		if not Unit:GetAttribute("OriginalSpeed") then
			Unit:SetAttribute("OriginalSpeed", Unit:GetAttribute("PermanentAttackSpeedMulti"))
		end

		if #BuffUnits > 0 then
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("OriginalDamageMulti")+0.25)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed")-0.1)
		else
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("OriginalDamageMulti"))
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed"))
		end

	end,
	
	onRemove = function(self, Unit: Model)
		
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitIndividualID = Unit:GetAttribute("IUUID")

		local BuffUnits = {}

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange then
				if (string.match(UnitToCheck.Name, "Luffy") or UnitToCheck.Name == "Luffy [DR] [Evo]" or UnitToCheck.Name == "Luffy [DR]") then
					table.insert(BuffUnits, UnitToCheck)
				end
			end
		end

		if not Unit:GetAttribute("OriginalDamageMulti") then
			Unit:SetAttribute("OriginalDamageMulti", Unit:GetAttribute("PermanentDamageMulti"))
		end

		if not Unit:GetAttribute("OriginalSpeed") then
			Unit:SetAttribute("OriginalSpeed", Unit:GetAttribute("PermanentAttackSpeedMulti"))
		end

		if #BuffUnits > 0 then
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("OriginalDamageMulti")+0.25)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed")-0.1)
		else
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("OriginalDamageMulti"))
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed"))
		end

	end,

}

return Passive
