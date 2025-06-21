local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Tremor",
	PassiveDescription = "After each 30 eliminations the next attack will stun the enemies.",
	MaxPassiveStacks = 30,
	--ProcChance = 25,
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("TremorStacks") or 0

		if Stacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("TremorStacks", Stacks+1)
		end
	end,
	onAttack = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("TremorStacks") or 0
		Unit:SetAttribute("PassiveStun", false)

		if Stacks == Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("PassiveStun", true)
			Unit:SetAttribute("TremorStacks", 0)
		end
	end,
	--onWave = function(self, Unit: Model)
	--	local config = Unit:WaitForChild("configuration", 10)
	--	local ToBuff = {"Damage"}

	--	local StrongestManStacks = Unit:GetAttribute("StrongestManStacks2") or 0

	--	if StrongestManStacks < 20 then
	--		Unit:SetAttribute("StrongestManStacks2", StrongestManStacks+1)
	--		for _, StatName in ToBuff do
	--			local CurrentBuff = Unit:GetAttribute(`Permanent{StatName}Multi`)

	--			if CurrentBuff then
	--				Unit:SetAttribute(`Permanent{StatName}Multi`, CurrentBuff+.01)
	--			end
	--		end
	--	end
	--end,
}

return Passive
