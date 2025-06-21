local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Emptiness",
	PassiveDescription = "When no unit is in range, Gain +20% elemental damage."
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		
		local UnitsInRange = false
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			
			if IsInRange then
				UnitsInRange = true
				break
			end
		end
		
		if UnitsInRange then
			if Unit:GetAttribute("EmptinessBuff") then
				Unit:SetAttribute("EmptinessBuff", nil)
				Unit:SetAttribute("AmplifyAllElements", false)
				if not Unit:GetAttribute("AmplifiedElementPercent") then
					Unit:SetAttribute("AmplifiedElementPercent", 0)
				else
					Unit:SetAttribute("AmplifiedElementPercent", Unit:GetAttribute("AmplifiedElementPercent") - 20)
				end
			end
		else
			if not Unit:GetAttribute("EmptinessBuff") then
				Unit:SetAttribute("EmptinessBuff", true)
				Unit:SetAttribute("AmplifyAllElements", true)
				if not Unit:GetAttribute("AmplifiedElementPercent") then
					Unit:SetAttribute("AmplifiedElementPercent", 0)
				end
				Unit:SetAttribute("AmplifiedElementPercent", Unit:GetAttribute("AmplifiedElementPercent") + 20)
			end
		end
	end
}

return Passive
