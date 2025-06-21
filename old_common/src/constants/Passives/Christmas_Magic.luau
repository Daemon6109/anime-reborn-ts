local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Christmas Magic",
	PassiveDescription = "Attacks freeze enemies that are below 35% health; SPA -10% for 25 seconds after killing a frozen enemy",
	MaxPassiveStacks = 3,
	PercentPerStack = 0.1,
} 

Passive.callbacks = {
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0  then

			if Enemy.Health < Enemy.MaxHealth*.35 then
				local StatusEffect = _G.Registry.registry.StatusEffects["Frozen"] 

				if StatusEffect then
					StatusEffect:OnServer(Unit, {Enemy}, 3)
				end
			end
			--local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true --table.find(Enemy.StatusEffects, Passive.configuration.StatusNeeded)

			--if HasStatus then
			--	return Passive.configuration.PercentIncrease
			--end
		end

		return 1
	end,
	
	onKill = function(self, Unit: Model, Enemy:{any}?)
		local Stacks = Unit:GetAttribute("IceFrenzyStacks") or 0

		if Stacks < Passive.configuration.MaxPassiveStacks and Enemy.StatusEffects["Frozen"] then
			Unit:SetAttribute("IceFrenzyStacks", Stacks+1)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-Passive.configuration.PercentPerStack)
			task.delay(15 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				local Stacks2 = Unit:GetAttribute("IceFrenzyStacks")
				Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")+Passive.configuration.PercentPerStack)
				Unit:SetAttribute("IceFrenzyStacks", Stacks2-1)
			end)
		end
	end,
}

return Passive
