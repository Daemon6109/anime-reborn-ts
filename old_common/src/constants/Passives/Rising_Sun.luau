local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Rising Sun",
	PassiveDescription = "Attack applies `Burning` status, if unit attacks an enemy that already has burn dot he increases his own dmg by 0.2% up to 10%",
	StatusNeeded = "Burning"
}

Passive.callbacks = {
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
			local HasStatus = Enemy.StatusEffects[Passive.configuration.StatusNeeded] == true

			if HasStatus then
				local Stacks = Unit:GetAttribute("SunStacks") or 0
				if Stacks < 0.1 then
					Unit:SetAttribute("SunStacks", Stacks+0.002)
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.002)
				end
				return 1
			end
		end

		return 1
	end,
}

return Passive
