local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Submission Lock",
	PassiveDescription = "On every 15th attack, Stuns all the enemies hit for 2.5 seconds.",
}

Passive.callbacks = {
	onAttack = function(self, Unit: Model)

		Unit:SetAttribute("PassiveStun", false)
		local PassiveStacks = Unit:GetAttribute("PassiveStacks") or 0
		Unit:SetAttribute("PassiveStacks", PassiveStacks + 1)
		if PassiveStacks >= 15 then
			Unit:SetAttribute("PassiveStacks", 0)
			Unit:SetAttribute("PassiveStun", true)
		end

	end,

	--onConditionalDamage = function(self, Unit: Model, Enemy: {any})
	--	if Enemy and Enemy.Health > 0 and Enemy.StatusEffects then
	--		local HasStatus = Enemy.StatusEffects["Stun"] == true

	--		if HasStatus then
	--			return 1.15
	--		end
	--	end

	--	return 1
	--end,
}

return Passive
