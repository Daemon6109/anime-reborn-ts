local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Wolf Pack",
	PassiveDescription = "Having 2 or more units in range will give all of them +5% crit damage and +15% crit chance",
	CritChanceBuff = 0.15,
	CritDamageBuff = 0.05
} 

local function apply(unit, amount)
	unit:SetAttribute("PermanentAttackCriticalDamage", unit:GetAttribute("PermanentAttackCriticalDamage") + amount.Damage)
	unit:SetAttribute("PermanentAttackCriticalChance", unit:GetAttribute("PermanentAttackCriticalChance") + amount.Chance)
end

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		local BuffUnits = {}

		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange then
				table.insert(BuffUnits, UnitToCheck)
			end
		end

		if #BuffUnits >= 2 then

			if not Unit:GetAttribute("WolfPackBuff") then
				Unit:SetAttribute("WolfPackBuff", true)
				apply(Unit, {
					Damage = Passive.configuration.CritDamageBuff,
					Chance = Passive.configuration.CritChanceBuff
				})
			end

			for _, UnitToBuff in BuffUnits do
				if not UnitToBuff:GetAttribute("WolfPackBuff") then
					UnitToBuff:SetAttribute("WolfPackBuff", true)
					UnitToBuff:SetAttribute("WolfPackBuffID", UnitIndividualID)
					apply(UnitToBuff, {
						Damage = Passive.configuration.CritDamageBuff,
						Chance = Passive.configuration.CritChanceBuff
					})
				end
			end

			return
		end

		if #BuffUnits < 2 then

			if Unit:GetAttribute("WolfPackBuff") then
				Unit:SetAttribute("WolfPackBuff", false)
				apply(Unit, {
					Damage = -Passive.configuration.CritDamageBuff,
					Chance = -Passive.configuration.CritChanceBuff
				})
			end

			for _, UnitToBuff in BuffUnits do
				if UnitToBuff:GetAttribute("WolfPackBuff") then
					UnitToBuff:SetAttribute("WolfPackBuff", nil)
					UnitToBuff:SetAttribute("WolfPackBuffID", nil)
					apply(UnitToBuff, {
						Damage = -Passive.configuration.CritDamageBuff,
						Chance = -Passive.configuration.CritChanceBuff
					})
				end
			end
		end
	end,
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("WolfPackBuff") == true and UnitToCheck:GetAttribute("WolfPackBuffID") == UnitIndividualId then
				UnitToCheck:SetAttribute("WolfPackBuff", nil)
				UnitToCheck:SetAttribute("WolfPackBuffID", nil)
				apply(UnitToCheck, {
					Damage = -Passive.configuration.CritDamageBuff,
					Chance = -Passive.configuration.CritChanceBuff
				})
			end
		end
	end,
}

return Passive
