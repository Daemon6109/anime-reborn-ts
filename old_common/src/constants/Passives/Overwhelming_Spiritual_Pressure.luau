local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Overwhelming Spiritual Pressure",
	PassiveDescription = "The closer the enemies, The more damage they'll take (up to 20% more)"
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)

		if Enemy and Enemy.Health > 0 then
			local Distance = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, Enemy.Position)
			if Distance <= UnitRange then
				return math.clamp(1.2 - (Distance / UnitRange * 0.2), 0, 1.2)
			end	
		end

		return 1
	end,
}

return Passive
