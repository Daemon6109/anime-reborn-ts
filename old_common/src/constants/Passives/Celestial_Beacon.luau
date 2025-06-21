local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Celestial Beacon",
	PassiveDescription = "Boosts the range of all ground units in his range by 20% while boosting the damage of all hills units by 10%.",
} 

Passive.callbacks = {
	
	onUnitsInRange = function(self, Unit: Model)
		
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange and not UnitToCheck:GetAttribute("VYBuff2") then
				--print("here")
				if UnitToCheck.configuration.PlacementType.Value == "Ground" then
					UnitToCheck:SetAttribute("VYBuffID2", UnitIndividualID)
					UnitToCheck:SetAttribute("VYBuff2", true)
					--UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")+0.1)
					UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")+0.2) 
				elseif UnitToCheck.configuration.PlacementType.Value == "Air" then
					UnitToCheck:SetAttribute("VYBuffID2", UnitIndividualID)
					UnitToCheck:SetAttribute("VYBuff2", true)
					UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")+0.1)
				end
			end
		end

	end,
	
	onRemove = function(self, Unit: Model)
		
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		for _, UnitToCheck in CurrentlyPlaced do
			
			if not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("VYBuffID2") == UnitIndividualID then
				UnitToCheck:SetAttribute("VYBuffID2", nil)
				UnitToCheck:SetAttribute("VYBuff2", false)
				if UnitToCheck.configuration.PlacementType.Value == "Ground" then
					UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")-0.2) 
				elseif UnitToCheck.configuration.PlacementType.Value == "Air" then
					UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")-0.1)
				end
			end
		end
		
	end,
}

return Passive
