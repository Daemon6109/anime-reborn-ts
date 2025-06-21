local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Shadow Clone",
	PassiveDescription = "For each Noroto in range, unit gains +3% more attack damage.",
	PercentIncrease = .03
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local config = Unit:WaitForChild("configuration", 10)
		if Unit:GetAttribute("ShadowCloneBuffIncrease") then
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-Unit:GetAttribute("ShadowCloneBuffIncrease")) 	
		end
		Unit:SetAttribute("ShadowCloneBuffIncrease", 0)
		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if Unit:GetAttribute("IUUID") == UnitToCheck:GetAttribute("IUUID") then continue end
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			if IsInRange and Unit.Name == UnitToCheck.Name then
				if config then
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease) 	
					local totalBuff = Unit:GetAttribute("ShadowCloneBuffIncrease")
					Unit:SetAttribute("ShadowCloneBuffIncrease", totalBuff + Passive.configuration.PercentIncrease)
					
				end
			end
		end
	end
}

return Passive
