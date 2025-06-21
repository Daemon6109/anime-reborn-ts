local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Fighting Spirit",
	PassiveDescription = "On attack start each enemy in his range increases his crit chance by 1%, up to 15%",
	MaxPassiveStacks = 15,
	PercentPerStack = 0.01,
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model, DataPack: {any})
		if not Unit:GetAttribute("FightingSpiritStacks") then
			Unit:SetAttribute("FightingSpiritStacks", 0)
		end
		
		local NPC_CACHE = _G.serverServices.UnitHandler:GetEnemiesInRangeUnsorted(Unit)

		local InRangeCount = math.clamp(#NPC_CACHE, 0, Passive.configuration.MaxPassiveStacks)

		local CurrentFightingSpiritStacks = Unit:GetAttribute("FightingSpiritStacks")
		local Difference = (InRangeCount-CurrentFightingSpiritStacks)
		Unit:SetAttribute("FightingSpiritStacks", CurrentFightingSpiritStacks+Difference)

		local CurrentMultiDMG = Unit:GetAttribute("PermanentAttackCriticalChance")
		
		Unit:SetAttribute("PermanentAttackCriticalChance", CurrentMultiDMG+(Passive.configuration.PercentPerStack*Difference))
	end,
}

return Passive
