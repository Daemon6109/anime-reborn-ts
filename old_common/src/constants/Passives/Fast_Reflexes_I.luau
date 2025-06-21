local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Fast Reflexes I",
	PassiveDescription = "She deals 20% more dmg against `Slow` enemies, for every 50 `Slow` enemies that are eliminated this unit range gets increased by 2.5% upto 10 % ",
	StatusNeeded = "Slow"
}

Passive.callbacks = {
	
	onKill = function(self: {any}, Unit: Model, Enemy: {any}?)
		local Stacks = Unit:GetAttribute("FastReflexesStacks") or 0

		if Stacks < 5 then
			if Enemy and Enemy.StatusEffects then
				local HasStatus = Enemy.StatusEffects["Slow"] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)
				if HasStatus then
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.025)
				end
			end
			Unit:SetAttribute("FastReflexesStacks", Stacks+1)
		end

	end,
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Enemy.StatusEffects["Slow"] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)

			if HasStatus then
				return 1.2
			end
		end

		return 1
	end,
}

return Passive
