local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Scarlet Retribution",
	PassiveDescription = "if boss is on the map this unit does 50% more damage against the boss and applies stun (every 15th hit) (5s cooldown).",
	StatusNeeded = "Stun",
} 

Passive.callbacks = {
	
	onAttack = function(self, Unit: Model)

		local OnCooldown = Unit:GetAttribute("PrisonCooldown2") or false
		local BossOnMap = Unit:GetAttribute("BossOnMap") or false
		
		if OnCooldown then return end
		if not BossOnMap then return end
		
		Unit:SetAttribute("PassiveStun", false)
		local PassiveStacks = Unit:GetAttribute("PassiveStacks2") or 0

		if PassiveStacks >= 15 then
			Unit:SetAttribute("PassiveStacks2", 0)
			Unit:SetAttribute("PrisonCooldown2", true)
			
			Unit:SetAttribute("PassiveStun", true)
			task.delay(5/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute("PrisonCooldown2", false)
			end)
		end
		Unit:SetAttribute("PassiveStacks2", PassiveStacks + 1)

	end,

	onConditionalDamage = function(self, Unit: Model, Enemy: {any})

		local BossOnMap = Unit:GetAttribute("BossOnMap") or false
		if Enemy and Enemy.Health > 0 then
			if BossOnMap and Enemy.IsBoss then
				return 1.5
			end
		end
		return 1

	end,

	onServerTick = function(self, Unit: Model, Delta: number)
		local BossOnMap = Unit:GetAttribute("BossOnMap") or false
		for index, EnemyConstruct in pairs(_G.Constructs) do
			if EnemyConstruct.IsBoss then
				Unit:SetAttribute("BossOnMap", true)
				break
			else
				Unit:SetAttribute("BossOnMap", false)
			end
		end

		if BossOnMap and not Unit:GetAttribute("EgoBossBuffed") then
			Unit:SetAttribute("PermanentDmgToBossMulti", Unit:GetAttribute("PermanentDmgToBossMulti") + 0.5)
			Unit:SetAttribute("EgoBossBuffed", true)
		elseif not BossOnMap and Unit:GetAttribute("EgoBossBuffed") then
			Unit:SetAttribute("EgoBossBuffed", false)
			Unit:SetAttribute("PermanentDmgToBossMulti", Unit:GetAttribute("PermanentDmgToBossMulti") - 0.5)
		end
	end,
}

return Passive
