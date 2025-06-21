local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Captain's Presence",
	PassiveDescription = "Allies in range get +15% CRIT RATE and +15% CRIT DMG (non-stackable)",
	PercentIncrease = .15,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitIndividualID = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			local BuffDiff = IsInRange and Passive.configuration.PercentIncrease or -Passive.configuration.PercentIncrease 
			local HasBuff = UnitToCheck:GetAttribute("CaptainPresenceBuff")
			
			if not HasBuff and IsInRange and UnitToCheck:GetAttribute("CaptainPresenceId") == nil then
				UnitToCheck:SetAttribute("CaptainPresenceId", UnitIndividualID)
				UnitToCheck:SetAttribute("CaptainPresenceBuff", IsInRange)
				UnitToCheck:SetAttribute("PermanentAttackCriticalDamage", UnitToCheck:GetAttribute("PermanentAttackCriticalDamage")+Passive.configuration.PercentIncrease)
				UnitToCheck:SetAttribute("PermanentAttackCriticalChance", UnitToCheck:GetAttribute("PermanentAttackCriticalChance")+Passive.configuration.PercentIncrease)
			end
		end
	end,
	
	onRemove = function(self, Unit: Model)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		
		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("CaptainPresenceBuff") == true and UnitToCheck:GetAttribute("CaptainPresenceId") == UnitIndividualID then
				UnitToCheck:SetAttribute("CaptainPresenceBuff", false)
				UnitToCheck:SetAttribute("CaptainPresenceId", nil)
				UnitToCheck:SetAttribute("PermanentAttackCriticalDamage", UnitToCheck:GetAttribute("PermanentAttackCriticalDamage")-Passive.configuration.PercentIncrease)
				UnitToCheck:SetAttribute("PermanentAttackCriticalChance", UnitToCheck:GetAttribute("PermanentAttackCriticalChance")-Passive.configuration.PercentIncrease)
			end
		end
	end,
}

return Passive
