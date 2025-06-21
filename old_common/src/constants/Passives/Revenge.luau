local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Revenge",
	PassiveDescription = "When a boss is on map, String Mage gains 10% Damage, 25% Range, 25% Critical Chance."
} 

Passive.callbacks = {
	
	onServerTick = function(self, Unit: Model, Delta: number)
		
		local BossOnMap = false
		for index, EnemyConstruct in pairs(_G.Constructs) do
			if EnemyConstruct.IsBoss then
				BossOnMap = true
				break
			end
		end

		if BossOnMap and not Unit:GetAttribute("EgoBossBuffed") then
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti") + 0.05)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+.1)
			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+0.25)
			Unit:SetAttribute("EgoBossBuffed", true)
		elseif not BossOnMap and Unit:GetAttribute("EgoBossBuffed") then
			Unit:SetAttribute("EgoBossBuffed", false)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti") - 0.05)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-.1)
			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")-0.25)
		end
		
	end,
	
}

return Passive
