local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Samurai's Spirit II",
	PassiveDescription = "Each friendly unit on his range gives him a +4% crit chance and crit damage, stacks up to 40%.",
	MaxPassiveStacks = 10,
	PercentPerStack = 0.04,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()

		if not Unit:GetAttribute("SamuraiSpiritStacks") then
			Unit:SetAttribute("SamuraiSpiritStacks", 0)
		end

		local InRangeCount = 0

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local CurrentSamuraiSpiritStacks = Unit:GetAttribute("SamuraiSpiritStacks")

			if FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange and InRangeCount < Passive.configuration.MaxPassiveStacks then
				InRangeCount += 1
			end
		end

		local CurrentSamuraiSpiritStacks = Unit:GetAttribute("SamuraiSpiritStacks")
		local Difference = (InRangeCount-CurrentSamuraiSpiritStacks)
		Unit:SetAttribute("SamuraiSpiritStacks", CurrentSamuraiSpiritStacks+Difference)

		local CurrentMultiDMG = Unit:GetAttribute("PermanentAttackCriticalDamage")
		local CurrentMultiCHANCE = Unit:GetAttribute("PermanentAttackCriticalChance")

		Unit:SetAttribute("PermanentAttackCriticalDamage", CurrentMultiDMG+(Passive.configuration.PercentPerStack*Difference))
		Unit:SetAttribute("PermanentAttackCriticalChance", CurrentMultiCHANCE+(Passive.configuration.PercentPerStack*Difference))
	end,
}

return Passive
