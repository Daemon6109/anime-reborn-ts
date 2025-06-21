local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Gravitational impacts",
	PassiveDescription = "Unit `Slows` enemies, Slowed enemies takes 15% more damage. Also, Buffs Dark Units by 10%.",
	PercentIncrease = 1.15,
	StatusNeeded = "Slow"
} 

Passive.callbacks = {

	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)

			if HasStatus then
				return Passive.configuration.PercentIncrease
			end
		end

		return 1
	end,
	
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
				UnitToCheck:SetAttribute("PermanentAttackCriticalDamage", UnitToCheck:GetAttribute("PermanentAttackCriticalDamage")+0.1)
				UnitToCheck:SetAttribute("PermanentAttackCriticalChance", UnitToCheck:GetAttribute("PermanentAttackCriticalChance")+0.1)
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
				UnitToCheck:SetAttribute("PermanentAttackCriticalDamage", UnitToCheck:GetAttribute("PermanentAttackCriticalDamage")-0.1)
				UnitToCheck:SetAttribute("PermanentAttackCriticalChance", UnitToCheck:GetAttribute("PermanentAttackCriticalChance")-0.1)
			end
		end
	end,

}

return Passive
