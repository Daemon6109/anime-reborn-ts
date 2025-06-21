local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Pure Progress",
	PassiveDescription = "Every attack increases his critical chance by 5% until he critical strikes an enemy then it resets back to normal, every time he critical strikes an enemy his critical dmg increases by 2% up to 14%.",
} 

Passive.callbacks = {

	onAttack = function(self, Unit: Model)

		local config = Unit:WaitForChild("configuration", 10)
		local JirenStacks = Unit:GetAttribute("JirenStacks") or 0
		
		Unit:SetAttribute("JirenStacks", JirenStacks+0.05)
		Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+0.05)

	end,

	onCriticalHit = function(self, Unit: Model, Enemy: {any})
		local JirenStacks = Unit:GetAttribute("JirenStacks") or 0
		local JirenStacksDamage = Unit:GetAttribute("JirenStacksDamage") or 0
		
		if Enemy and Enemy.Health > 0 then
			Unit:SetAttribute("JirenStacks", 0)
			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")-JirenStacks)
			
			if JirenStacksDamage < 7 then
				Unit:SetAttribute("JirenStacksDamage", JirenStacksDamage+1)
				Unit:SetAttribute("PermanentAttackCriticalDamage", Unit:GetAttribute("PermanentAttackCriticalDamage")+0.02)
			end
			
		end
	end,

}

return Passive
