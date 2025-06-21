local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Pun support",
	PassiveDescription = "Each Pun in this unit radius buffs it's damage and range by 3% ",
	PercentIncrease = .03
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local config = Unit:WaitForChild("configuration", 10)
		if Unit:GetAttribute("PunBuffIncrease") then
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-Unit:GetAttribute("PunBuffIncrease"))
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")-Unit:GetAttribute("PunBuffIncrease"))
		end
		Unit:SetAttribute("PunBuffIncrease", 0)
		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if Unit:GetAttribute("IUUID") == UnitToCheck:GetAttribute("IUUID") then continue end
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			if IsInRange and Unit.Name == UnitToCheck.Name then
				if config then
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease) 
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+Passive.configuration.PercentIncrease) 	
					local totalBuff = Unit:GetAttribute("PunBuffIncrease")
					Unit:SetAttribute("PunBuffIncrease", totalBuff + Passive.configuration.PercentIncrease)
				end
			end
		end
	end
}

return Passive
