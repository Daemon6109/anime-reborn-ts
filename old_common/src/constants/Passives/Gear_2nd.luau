local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "GEAR",
	PassiveDescription = "Laugfy feels safer with more allies around, increasing his attack speed by 5% for every unit within his range, up to a maximum of 20%."
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
				table.insert(BuffUnits, UnitToCheck)
			end
		end
		
		if not Unit:GetAttribute("OriginalSpeed") then
			Unit:SetAttribute("OriginalSpeed", Unit:GetAttribute("PermanentAttackSpeedMulti"))
		end
		
		--warn("Original Speed", Unit:GetAttribute("OriginalSpeed"))

		if #BuffUnits > 0 then
			local Buff = 0.05
			if #BuffUnits <= 4 then
				Buff = (5 * #BuffUnits)/100
			else
				Buff = (5 * 4)/100
			end
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed")-tonumber(Buff))
		--else
			--Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed")-.05)
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
				table.insert(BuffUnits, UnitToCheck)
			end
		end

		if not Unit:GetAttribute("OriginalSpeed") then
			Unit:SetAttribute("OriginalSpeed", Unit:GetAttribute("PermanentAttackSpeedMulti"))
		end

		if #BuffUnits > 0 then
			local Buff = 0.05
			if #BuffUnits <= 4 then
				Buff = (5 * #BuffUnits)/100
			else
				Buff = (5 * 4)/100
			end
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed")-tonumber(Buff))
		--else
			--Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed")-.05)
		end
		
	end,

}

return Passive
