local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Death Beam",
	PassiveDescription = "Attacks inflict `Dark Flames` and for each enemy inflicted with `Dark Flames` in his range he gains 0.2% dot dmg increase up to 15%, at max stacks ground units in his range gain 5% dmg.",
} 

Passive.callbacks = {

	onAttack = function(self, Unit: Model, DataPack: {any})

		local NPC_CACHE = _G.serverServices.UnitHandler:GetEnemiesInRangeUnsorted(Unit)
		local EffectedUnits = {};

		for i,v in pairs(NPC_CACHE) do
			local Unit = v.npc
			if Unit.StatusEffects["Dark Flames"] then
				table.insert(EffectedUnits, v.npc)
			end
		end

		local Stacks = Unit:GetAttribute("DotStacks") or 0

		if Stacks < 76 then
			Unit:SetAttribute("DotStacks", Stacks+#EffectedUnits)
			Unit.configuration.AttackEffectDamageMultiplier.Value += .002
			--Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.002)
		end

		if Stacks >= 75 then
			Unit:SetAttribute("MaxDoTStacks", true)
		end

	end,

	onUnitsInRange = function(self, Unit: Model)

		local IsMaxStacks = Unit:GetAttribute("MaxDoTStacks") or false

		if not IsMaxStacks then return end

		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		local HighestCost = 0;		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange and not UnitToCheck:GetAttribute("FreDarknessBuff") then
				print("here freiza")
				if UnitToCheck.configuration.PlacementType.Value == "Ground" then
					UnitToCheck:SetAttribute("FreDarknessId", UnitIndividualID)
					UnitToCheck:SetAttribute("FreDarknessBuff", true)
					UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")+0.05)
				end
			end
		end

		if HighestCost < 2500 then
			Unit:SetAttribute("HighestCost", true)
		else
			Unit:SetAttribute("HighestCost", false)
		end

	end,

	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("FreDarknessBuff") == true and UnitToCheck:GetAttribute("FreDarknessId") == UnitIndividualId then
				UnitToCheck:SetAttribute("FreDarknessBuff", false)
				UnitToCheck:SetAttribute("FreDarknessId", nil)
				UnitToCheck:SetAttribute("PermanentDamageMulti", UnitToCheck:GetAttribute("PermanentDamageMulti")-0.05)
			end
		end
	end,
}

return Passive
