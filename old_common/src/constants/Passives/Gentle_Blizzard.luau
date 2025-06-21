local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Gentle Blizzard",
	PassiveDescription = "Slows all enemies in range on every 15th elimination. Slowed enemies takes 15% more damage.",
	MaxPassiveStacks = 10,
	--ProcChance = 25,
	PercentIncrease = 1.15,
	StatusNeeded = "Slow"
}

Passive.callbacks = {
	
	onKill = function(self: {any}, Unit: Model, Enemy: {any}?)
		local Stacks = Unit:GetAttribute("GentleStacks") or 0

		if Stacks >= 15 then
			Unit:SetAttribute("GentleStacks", 0)
			
			local FastVector = require(replicated.Libs.FastVector).new()
			local BuffLib = require(replicated.Libs.BuffLib)
			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local FastVector = require(replicated.Libs.FastVector).new()
			
			for index, EnemyConstruct in pairs(_G.Constructs) do
				local Distance = FastVector:FastMagnitudeVec3(Enemy.Position, EnemyConstruct["Position"])
				local IsInRange = Distance <= UnitRange

				if IsInRange then
					local StatusEffect = _G.Registry.registry.StatusEffects["Slow"] 

					if StatusEffect then
						StatusEffect:OnServer(Unit, {EnemyConstruct}, 5)
					end
				end
			end
			FastVector = nil
		else
			Unit:SetAttribute("GentleStacks", Stacks + 1)
		end

	end,
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)

			if HasStatus then
				return Passive.configuration.PercentIncrease
			end
		end

		return 1
	end,
}

return Passive
