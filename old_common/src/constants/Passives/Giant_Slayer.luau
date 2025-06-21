local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Giant Slayer",
	PassiveDescription = "Everytime this unit attacks a non boss enemy this unit gains 0.5% dmg and 1% range ( upto 10% and 5% ). However, if this unit is attacking a boss gain 1% Damage every attack and 2% range ( upto 5% and 6% )",
}

Passive.callbacks = {

	--onAttack = function(self, Unit: Model)

	--	local OnCooldown = Unit:GetAttribute("PrisonCooldown") or false

	--	if not Unit:GetAttribute("StunEffectiveActive") then return end
	--	if OnCooldown then return end

	--	Unit:SetAttribute("PassiveStun", false)

	--	local PassiveStacks = Unit:GetAttribute("PassiveStacks") or 0

	--	if PassiveStacks >= 5 then
	--		Unit:SetAttribute("PassiveStacks", 0)
	--		Unit:SetAttribute("PrisonCooldown", true)
	--		Unit:SetAttribute("PassiveStun", true)
	--		task.delay(5, function()
	--			Unit:SetAttribute("PrisonCooldown", false)
	--		end)
	--	end
	--	Unit:SetAttribute("PassiveStacks", PassiveStacks + 1)

	--end,

	onConditionalDamage = function(self, Unit: Model, Enemy: {any})

		local StacksDamage = Unit:GetAttribute("StacksDamage") or 0
		local StacksRange = Unit:GetAttribute("StacksRange") or 0
		
		local StacksDamage2 = Unit:GetAttribute("StacksDamage2") or 0
		local StacksRange2 = Unit:GetAttribute("StacksRange2") or 0

		if Enemy and Enemy.Health > 0 then
			if Enemy.IsBoss then
				if StacksDamage2 < 1 then
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.05)
					Unit:SetAttribute("StacksDamage2", StacksDamage2+1)
				end
				if StacksRange2 < 3 then
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.02)
					Unit:SetAttribute("StacksRange2", StacksRange2+1)
				end
			else
				if StacksDamage < 20 then
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.005)
					Unit:SetAttribute("StacksDamage", StacksDamage+1)
				end
				if StacksRange < 5 then
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.01)
					Unit:SetAttribute("StacksRange", StacksRange+1)
				end
			end		
		end
		return 1
	end,


	--onKill = function(self, Unit: Model, Enemy:{any}?)
	--	local Stacks = Unit:GetAttribute("RangeStacks") or 0

	--	if Stacks < 0.15 and Enemy.StatusEffects["Stun"] then
	--		Unit:SetAttribute("RangeStacks", Stacks+0.01)
	--		Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.01)
	--	end

	--	if Stacks >= 0.15 then
	--		Unit:SetAttribute("StunEffectiveActive", true)
	--	end
	--end,

}

return Passive
