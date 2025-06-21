local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Bungee Counter",
	PassiveDescription = "If Stunned, next attack does 300% more damage, and gains 1% more damage upto 5%.",
}

Passive.callbacks = {
	
	onStunned = function(self, Unit: Model)
		Unit:SetAttribute("StunnedApplied", true)
	end,
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Unit:GetAttribute("StunnedApplied")

			if HasStatus then
				local Stacks = Unit:GetAttribute("BungeeStacks") or 0
				if Stacks < 0.05 then
					Unit:SetAttribute("BungeeStacks", Stacks+0.01)
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.01)
				end
				return 3
			end
		end

		return 1
	end,
	
}

return Passive
