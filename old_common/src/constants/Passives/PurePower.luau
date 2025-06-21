local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Pure Power",
	PassiveDescription = "After 40 eliminations his power awakens giving him a 35% damage increase and a 25% range increase. lasts 45s. cooldown: 45s",
	MaxPassiveStacks = 40,
	--ProcChance = 25,
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("PowerStacks") or 0
		local Mode = Unit:GetAttribute("PowerMode") or false
		
		if Mode then return end

		if Stacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("PowerStacks", Stacks+1)
		else
			Unit:SetAttribute("PowerStacks", 0)
			Unit:SetAttribute("PowerMode", true)
			
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+.35)
			Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+.25) 
			
			task.delay(45/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute("PowerMode", false)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-.35)
				Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")-.25) 
			end)
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
