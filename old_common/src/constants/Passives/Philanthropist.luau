local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Philanthropist",
	PassiveDescription = "First 5 units within Speedcart's range get 15% discount on upgrades (Non-stackable)",
	PercentIncrease = .15,
	MaxPassiveStacks = 5,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local CurrentStacksInitial = Unit:GetAttribute("PhilanthropistStacks") or 0
		local BuffedCountCheck = 0
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck:GetAttribute("PhilanthropistId") == UnitIndividualID then
				BuffedCountCheck += 1
			end
		end
		
		if CurrentStacksInitial ~= BuffedCountCheck then
			Unit:SetAttribute("PhilanthropistStacks", CurrentStacksInitial+(BuffedCountCheck-CurrentStacksInitial))
		end
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			local BuffDiff = -Passive.configuration.PercentIncrease 
			local HasBuff = UnitToCheck:GetAttribute("PhilanthropistBuff")
			local CurrentStacks = Unit:GetAttribute("PhilanthropistStacks") or 0
			
			if not HasBuff and IsInRange and CurrentStacks < Passive.configuration.MaxPassiveStacks then
				Unit:SetAttribute("PhilanthropistStacks", CurrentStacks+1)
				UnitToCheck:SetAttribute("PhilanthropistBuff", IsInRange)
				UnitToCheck:SetAttribute("PhilanthropistId", Unit:GetAttribute("IUUID"))
				UnitToCheck:SetAttribute("PermanentPriceMulti", UnitToCheck:GetAttribute("PermanentPriceMulti")+BuffDiff)
			end
		end
	end,
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")
		
		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("PhilanthropistBuff") == true and UnitToCheck:GetAttribute("PhilanthropistId") == UnitIndividualId then
				UnitToCheck:SetAttribute("PhilanthropistBuff", false)
				UnitToCheck:SetAttribute("PhilanthropistId", nil)
				UnitToCheck:SetAttribute("PermanentPriceMulti", UnitToCheck:GetAttribute("PermanentPriceMulti")+Passive.configuration.PercentIncrease)
			end
		end
	end,
}

return Passive
