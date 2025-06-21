local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Chain Lightning",
	PassiveDescription = "If other units are stunned inside Lucky's range, Lucky gets +5% DMG and +5% RNG, up to +25% increase.",
	MaxPassiveStacks = 5,
	PercentPerStack = 0.05,
} 

Passive.callbacks = {
	onAllyStunned = function(self, Unit: Model, Ally: Model)
		local Stacks = Unit:GetAttribute("ChainLightningStacks") or 0
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, Ally.HumanoidRootPart.Position) <= UnitRange
		
		if Stacks < Passive.configuration.MaxPassiveStacks and IsInRange then
			Unit:SetAttribute("ChainLightningStacks", Stacks+1)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentPerStack)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+Passive.configuration.PercentPerStack)
		end
	end,
	onAllyStunEnded = function(self, Unit: Model, Ally: Model)
		local Stacks = Unit:GetAttribute("ChainLightningStacks") or 0
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, Ally.HumanoidRootPart.Position) <= UnitRange
		
		if Stacks ~= 0 and IsInRange then
			Unit:SetAttribute("ChainLightningStacks", Stacks-1)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-Passive.configuration.PercentPerStack)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")-Passive.configuration.PercentPerStack)
		end
	end,
}

return Passive