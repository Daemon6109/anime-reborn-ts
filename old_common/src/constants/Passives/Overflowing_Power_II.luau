local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Overflowing Power II",
	PassiveDescription = "On attack start each enemy in range increases damage by 1%, up to 25%",
	MaxPassiveStacks = 25,
	PercentPerStack = 0.01,
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model, DataPack: {any})
		if not Unit:GetAttribute("OverflowingPowerStacks") then
			Unit:SetAttribute("OverflowingPowerStacks", 0)
		end
		
		local NPC_CACHE = _G.serverServices.UnitHandler:GetEnemiesInRangeUnsorted(Unit)

		local InRangeCount = math.clamp(#NPC_CACHE, 0, Passive.configuration.MaxPassiveStacks)

		local CurrentOverflowingPowerStacks = Unit:GetAttribute("OverflowingPowerStacks")
		local Difference = (InRangeCount-CurrentOverflowingPowerStacks)
		Unit:SetAttribute("OverflowingPowerStacks", CurrentOverflowingPowerStacks+Difference)

		local CurrentMultiDMG = Unit:GetAttribute("PermanentDamageMulti")
		
		Unit:SetAttribute("PermanentDamageMulti", CurrentMultiDMG+(Passive.configuration.PercentPerStack*Difference))
	end,
}

return Passive
