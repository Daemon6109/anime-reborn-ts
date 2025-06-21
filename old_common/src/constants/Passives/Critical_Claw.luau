local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Critical Claw",
	PassiveDescription = "Critical hits infflicts enemies with permanent `Scar` and `Slow` for 2s, Criticals hits increases damage by 1% up to 10%",
} 

Passive.callbacks = {
	onCriticalHit = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 then
			_G.Registry.registry.StatusEffects.PermaBleed:OnServer(Unit, {Enemy}, 999)
			_G.Registry.registry.StatusEffects.Slow:OnServer(Unit, {Enemy}, 2)
			local Stacks = Unit:GetAttribute("CritClawStacks") or 0
			
			if Stacks < 10 then
				Unit:SetAttribute("CritClawStacks", Stacks + 1)
				Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage") + 0.01)
			end
		end
	end,
}

return Passive
