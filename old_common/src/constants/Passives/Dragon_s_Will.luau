local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Dragon's Will",
	PassiveDescription = "Reduces other unit's special ability cooldown by 15%",
	--MaxPassiveStacks = 10,
	--PercentPerStack = 0.005,
	PercentIncrease = 0.15,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local CurrentStacksInitial = Unit:GetAttribute("KaidoDragonsWillStacks") or 0
		--local BuffedCountCheck = 0

		--for _, UnitToCheck in CurrentlyPlaced do
		--	if UnitToCheck:GetAttribute("KaidoDragonsWillId") == UnitIndividualID then
		--		BuffedCountCheck += 1
		--	end
		--end

		--if CurrentStacksInitial ~= BuffedCountCheck then
		--	Unit:SetAttribute("KaidoDragonsWillStacks", CurrentStacksInitial+(BuffedCountCheck-CurrentStacksInitial))
		--end

		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			local BuffDiff = Passive.configuration.PercentIncrease 
			local HasBuff = UnitToCheck:GetAttribute("KaidoDragonsWillBuff")
			local CurrentStacks = Unit:GetAttribute("KaidoDragonsWillStacks") or 0

			if not HasBuff and IsInRange then
				Unit:SetAttribute("KaidoDragonsWillStacks", CurrentStacks+1)
				UnitToCheck:SetAttribute("KaidoDragonsWillBuff", IsInRange)
				UnitToCheck:SetAttribute("KaidoDragonsWillId", Unit:GetAttribute("IUUID"))
				UnitToCheck:SetAttribute("PermanentSpecialAbilityCdMulti", UnitToCheck:GetAttribute("PermanentSpecialAbilityCdMulti")-Passive.configuration.PercentIncrease)
			end
		end
	end,
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("KaidoDragonsWillBuff") == true and UnitToCheck:GetAttribute("KaidoDragonsWillId") == UnitIndividualId then
				UnitToCheck:SetAttribute("KaidoDragonsWillBuff", false)
				UnitToCheck:SetAttribute("KaidoDragonsWillId", nil)
				UnitToCheck:SetAttribute("PermanentSpecialAbilityCdMulti", UnitToCheck:GetAttribute("PermanentSpecialAbilityCdMulti")+Passive.configuration.PercentIncrease)
			end
		end
	end,
}

return Passive
