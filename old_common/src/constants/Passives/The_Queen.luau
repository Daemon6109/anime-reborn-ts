local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "The Queen",
	PassiveDescription = "Each other unit attack that is in range of the unit inscreases unit damage by 2% (80% max)",
} 

Passive.callbacks = {
	onAllyAttack = function(self, Unit: Model, Ally: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		
		local Distance = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, Ally.HumanoidRootPart.Position)
		local IsInRange = Distance <= UnitRange
		
		if IsInRange then
			local Stacks = Unit:GetAttribute("HeirStacks") or 0
			
			if Stacks < 80 then
				Unit:SetAttribute("HeirStacks", Stacks+2)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+.02)
			end
		end
		
		BuffLib = nil
		FastVector = nil
	end,
}

return Passive
