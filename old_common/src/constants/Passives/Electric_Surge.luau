local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Electric Surge",
	PassiveDescription = "After killing an enemy her next attack deals 15% more dmg and stuns enemies in range for 2 seconds.",
}

Passive.callbacks = {
	
	onKill = function(self: {any}, Unit: Model, Enemy: {any}?)
		local FastVector = require(replicated.Libs.FastVector).new()

		local Stacks = Unit:GetAttribute("ElectricStacks") or 0

		if Stacks >= 1 then
			Unit:SetAttribute("ElectricStacks", 0)

			local FastVector = require(replicated.Libs.FastVector).new()
			local BuffLib = require(replicated.Libs.BuffLib)
			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local FastVector = require(replicated.Libs.FastVector).new()

			for index, EnemyConstruct in pairs(_G.Constructs) do
				local Distance = FastVector:FastMagnitudeVec3(Enemy.Position, EnemyConstruct["Position"])
				local IsInRange = Distance <= UnitRange

				if IsInRange then
					local StatusEffect = _G.Registry.registry.StatusEffects["Stun"] 

					if StatusEffect then
						StatusEffect:OnServer(Unit, {EnemyConstruct}, 2)
					end
				end
			end
			Unit:SetAttribute("ESPP", true)
		else
			Unit:SetAttribute("ElectricStacks", Stacks + 1)
		end

		FastVector = nil
	end,

	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Unit:GetAttribute("ESPP") then
			Unit:SetAttribute("ESPP", false)
			return 1.15
		end
		return 1
	end,
}

return Passive
