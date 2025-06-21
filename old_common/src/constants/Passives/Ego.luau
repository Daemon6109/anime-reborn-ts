local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Ego",
	PassiveDescription = "-5% SPA for each ability usage (Up to -15%). +25% Range if there is a boss on the map.",
	PercentIncrease = 0.05,
	MaxPassiveStacks = 3,
} 

Passive.callbacks = {
	onSpecialAbility = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("EgoAbilityStacks") or 0

		if Stacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti") - Passive.configuration.PercentIncrease)
			Unit:SetAttribute("EgoAbilityStacks", Stacks + 1)
		end
	end,
	
	onServerTick = function(self, Unit: Model, Delta: number)
		local BossOnMap = false
		for index, EnemyConstruct in pairs(_G.Constructs) do
			if EnemyConstruct.IsBoss then
				BossOnMap = true
				break
			end
		end

		if BossOnMap and not Unit:GetAttribute("EgoBossBuffed") then
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti") + 0.25)
			Unit:SetAttribute("EgoBossBuffed", true)
		elseif not BossOnMap and Unit:GetAttribute("EgoBossBuffed") then
			Unit:SetAttribute("EgoBossBuffed", false)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti") - 0.25)
		end
	end,
}

return Passive
