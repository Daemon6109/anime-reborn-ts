local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Scalpel",
	PassiveDescription = "For every unit that is in range Sentinel gains +1% dmg (caps at 5%) and -1% spa (caps at -5%)"
} 

Passive.callbacks = {
	
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		
		local BuffUnits = {}
		local amount = 0
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			if IsInRange then
				table.insert(BuffUnits, UnitToCheck)
			end
		end
		
		if #BuffUnits > 5 then
			amount = 5
		else
			amount = #BuffUnits
		end
		
		if not Unit:GetAttribute("OriginalSpeed") then
			Unit:SetAttribute("OriginalSpeed", Unit:GetAttribute("PermanentAttackSpeedMulti"))
		end
		
		if not Unit:GetAttribute("OriginalDamage") then
			Unit:SetAttribute("OriginalDamage", Unit:GetAttribute("PermanentDamageMulti"))
		end

		if amount > 0 then
			local Buff = (amount)/100
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed")-tonumber(Buff))
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("OriginalDamage")+tonumber(Buff))
		end
	end,
	
	onRemove = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		local BuffUnits = {}
		local amount = 0
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			if IsInRange then
				table.insert(BuffUnits, UnitToCheck)
			end
		end

		if #BuffUnits > 5 then
			amount = 5
		else
			amount = #BuffUnits
		end

		if not Unit:GetAttribute("OriginalSpeed") then
			Unit:SetAttribute("OriginalSpeed", Unit:GetAttribute("PermanentAttackSpeedMulti"))
		end

		if not Unit:GetAttribute("OriginalDamage") then
			Unit:SetAttribute("OriginalDamage", Unit:GetAttribute("PermanentDamageMulti"))
		end

		if amount > 0 then
			local Buff = (amount)/100
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("OriginalSpeed")-tonumber(Buff))
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("OriginalDamage")+tonumber(Buff))
		end
	end,
	
}

return Passive
