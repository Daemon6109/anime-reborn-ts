local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Reborn!",
	PassiveDescription = "Allies sharing the same element as this unit gain 20% bonus damage and 15% increased range. Additionally, their SPA is reduced by 1% each wave, up to a maximum of 5%.If only same-element allies are within range, this unit gains 20% critical chance and 25% critical damage.",
} 

Passive.callbacks = {
	
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		
		local config = Unit:WaitForChild("configuration", 10)
		local OnlyLightUnits = true
		local IfBuffed = Unit:GetAttribute("RebornBuffed") or false
		
		local BuffedUnits = {};
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange then
				if UnitToCheck.configuration.Element.Value == "Light" then
					if not UnitToCheck:GetAttribute("RRVYBuff") then
						UnitToCheck:SetAttribute("RRVYBuffID", UnitIndividualID)
						UnitToCheck:SetAttribute("RRVYBuff", true)
						UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")+0.2)
						UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")+0.15)
					end
				else
					OnlyLightUnits = false
				end
				table.insert(BuffedUnits, UnitToCheck)
			end
		end
		
		if #BuffedUnits > 0 then
			if OnlyLightUnits then
				if not IfBuffed then
					Unit:SetAttribute("RebornBuffed", true)
					Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+0.2) 
					Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")+0.25)
				end
			end
		else
			if IfBuffed then
				Unit:SetAttribute("RebornBuffed", false)
				Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")-0.2) 
				Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")-0.25)
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
			
			if UnitToCheck:GetAttribute("RRVYBuffID") == UnitIndividualID then
				UnitToCheck:SetAttribute("RRVYBuffID", nil)
				UnitToCheck:SetAttribute("RRVYBuff", false)
				local BuffAmount = UnitToCheck:GetAttribute("RebornStacks")
				UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")-0.2)
				UnitToCheck:SetAttribute("PermanentRangeMulti", UnitToCheck:GetAttribute("PermanentRangeMulti")-0.15)
				if BuffAmount > 0 then
					UnitToCheck:SetAttribute("PermanentAttackSpeedMulti", UnitToCheck:GetAttribute("PermanentAttackSpeedMulti")+BuffAmount) 
				end
			end
		end
		
	end,
	
	onWave = function(self, Unit: Model)

		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		
		for _, UnitToCheck in CurrentlyPlaced do

			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("RRVYBuffID") == UnitIndividualID then
				local BuffAmount = UnitToCheck:GetAttribute("RebornStacks") or 0
				if BuffAmount < .05 then
					UnitToCheck:SetAttribute("RebornStacks", BuffAmount + .01)
					UnitToCheck:SetAttribute("PermanentAttackSpeedMulti", UnitToCheck:GetAttribute("PermanentAttackSpeedMulti")-.01) 
				end
			end
		end

	end,
	
}

return Passive
