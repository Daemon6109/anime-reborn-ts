local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Flame Power",
	PassiveDescription = "This unit builds up flame power for each elimination. At full energy his next 3-5 attacks deal 230% of his current damage",
	MaxPassiveStacks = 100,
} 

Passive.callbacks = {
	onKill = function(self, Unit: Model, Enemy: {any?})
		local ChargeStacks = Unit:GetAttribute("FlameCharge") or 0
			
		Unit:SetAttribute("FlameCharge", ChargeStacks + 1)	
		
		if ChargeStacks >= Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("FlameCharge", 0)
			Unit:SetAttribute("FlameChargeAttacks", math.random(3,5))
			--Unit:GetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+2.3)
		end
	end,
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		local ChargeAttackStacks = Unit:GetAttribute("FlameChargeAttacks") or 0
		if Enemy and Enemy.Health > 0 and ChargeAttackStacks > 0 then
			Unit:SetAttribute("FlameChargeAttacks", ChargeAttackStacks - 1)
			return 3.3
		end

		return 1
	end,
}

return Passive
