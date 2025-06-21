local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Wind Spirit's Blessing",
	PassiveDescription = "Deals +20% more damage to enemies infused by Wind element; Wind element allies in Yano's range gain +15% DMG (non-stackable)",
	TargetElement = "Wind",
	PercentIncrease = .15,
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:SetAttribute("AmplifiedElement", "Wind")
		Unit:SetAttribute("AmplifiedElementPercent", 20)
	end,
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

			if IsInRange and not UnitToCheck:GetAttribute("CloverWindSpiritBuff") and UnitToCheck.configuration.Element.Value == Passive.configuration.TargetElement then
				print("here")
				UnitToCheck:SetAttribute("CloverWindSpiritId", UnitIndividualID)
				UnitToCheck:SetAttribute("CloverWindSpiritBuff", true)
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

			if UnitToCheck:GetAttribute("CloverWindSpiritBuff") == true and UnitToCheck:GetAttribute("CloverWindSpiritId") == UnitIndividualId then
				UnitToCheck:SetAttribute("CloverWindSpiritBuff", false)
				UnitToCheck:SetAttribute("CloverWindSpiritId", nil)
				UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")-Passive.configuration.PercentIncrease)
			end
		end
	end,
}

return Passive
