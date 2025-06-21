local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Perfect Assistant",
	PassiveDescription = "All non farm units in Whis’ range gain a +10% Damage, +5% Range, and -5% SPA buff.",
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
			
			--and UnitToCheck.configuration.Element.Value == Passive.configuration.TargetElement
			if IsInRange and not UnitToCheck:GetAttribute("PDarknessBuff") then
				print("here assistant")
				UnitToCheck:SetAttribute("PDarknessId", UnitIndividualID)
				UnitToCheck:SetAttribute("PDarknessBuff", true)
				UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")+0.1)
				UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")+0.05)
				UnitToCheck:SetAttribute("PermanentAttackSpeedMulti", UnitToCheck:GetAttribute("PermanentAttackSpeedMulti")-.05) 
			end
		end
	end,
	
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("PDarknessBuff") == true and UnitToCheck:GetAttribute("PDarknessId") == UnitIndividualId then
				UnitToCheck:SetAttribute("PDarknessBuff", false)
				UnitToCheck:SetAttribute("PDarknessId", nil)
				UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")-0.1)
				UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")-0.05)
				UnitToCheck:SetAttribute("PermanentAttackSpeedMulti", UnitToCheck:GetAttribute("PermanentAttackSpeedMulti")+.05) 
			end
		end
	end,
	
}

return Passive
