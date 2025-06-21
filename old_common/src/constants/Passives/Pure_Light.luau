local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Pure Light",
	PassiveDescription = "All `Light` type units in range gain +20% DMG (non-stackable)",
	TargetElement = "Light",
	PercentIncrease = .20,
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

			if IsInRange and not UnitToCheck:GetAttribute("LightnessBuff") and UnitToCheck.configuration.Element.Value == Passive.configuration.TargetElement then
				--print("here")
				UnitToCheck:SetAttribute("LightnessId", UnitIndividualID)
				UnitToCheck:SetAttribute("LightnessBuff", true)
				UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease)
			end
		end
	end,
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("LightnessBuff") == true and UnitToCheck:GetAttribute("LightnessId") == UnitIndividualId then
				UnitToCheck:SetAttribute("LightnessBuff", false)
				UnitToCheck:SetAttribute("LightnessId", nil)
				UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")-Passive.configuration.PercentIncrease)
			end
		end
	end,
}

return Passive
