local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Monarch's Domain",
	PassiveDescription = "Whenever ally shadows are within Solo's range - Solo gains +10% DMG (non-stackable), While ally shadow units Gain -10% SPA"
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		
		local BuffUnits = {}
		local UnitsBuffable = {
			"Beru [Evo]", 
			"Beru [Evo2]", 
			"Iron [Evo]", 
			"Iron [Evo2]", 
			"Kargalgan [Evo]", 
			"Kargalgan [Evo2]"
		}
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			
			if IsInRange and (string.match(UnitToCheck.Name, "Igris") or table.find(UnitsBuffable, UnitToCheck.Name)) then
				if not Unit:GetAttribute("WarriorsResolveBuff") and not table.find(BuffUnits, UnitToCheck) then
					table.insert(BuffUnits, UnitToCheck)
				end
			end
		end
		
		if #BuffUnits > 0 and not Unit:GetAttribute("WarriorsResolveBuff") then
			Unit:SetAttribute("WarriorsResolveBuff", true)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+.1)
			
			for _, UnitToBuff in BuffUnits do
				if not UnitToBuff:GetAttribute("WarriorsResolveBuff") then
					UnitToBuff:SetAttribute("WarriorsResolveBuff", true)
					UnitToBuff:SetAttribute("OriginalAttackSpeedMulti", UnitToBuff:GetAttribute("PermanentAttackSpeedMulti")) 
					warn(UnitToBuff:GetAttribute("OriginalAttackSpeedMulti"))
					UnitToBuff:SetAttribute("PermanentAttackSpeedMulti", UnitToBuff:GetAttribute("PermanentAttackSpeedMulti")-.1)
					UnitToBuff:SetAttribute("WarriorsResolveBuffID", UnitIndividualID)
				end
			end
			
			return
		end
			
		if #BuffUnits <= 0 and Unit:GetAttribute("WarriorsResolveBuff") then
			Unit:SetAttribute("WarriorsResolveBuff", false)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-.1)
		end
	end,
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("WarriorsResolveBuff") == true and UnitToCheck:GetAttribute("WarriorsResolveBuffID") == UnitIndividualId then
				UnitToCheck:SetAttribute("WarriorsResolveBuff", false)
				UnitToCheck:SetAttribute("WarriorsResolveBuffID", nil)
				UnitToCheck:SetAttribute("PermanentAttackSpeedMulti", UnitToCheck:GetAttribute("PermanentAttackSpeedMulti")+.1)
			end
		end
	end,
}

return Passive
