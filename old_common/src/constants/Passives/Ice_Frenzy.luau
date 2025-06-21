local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Ice Frenzy",
	PassiveDescription = "SPA -10% for 15 seconds after killing a frozen enemy (down to -30%)",
	MaxPassiveStacks = 3,
	PercentPerStack = 0.1,
}

Passive.callbacks = {
	onKill = function(self, Unit: Model, Enemy:{any}?)
		local Stacks = Unit:GetAttribute("IceFrenzyStacks") or 0

		if Stacks < Passive.configuration.MaxPassiveStacks and Enemy.StatusEffects["Frozen"] == true then
			Unit:SetAttribute("IceFrenzyStacks", Stacks+1)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-Passive.configuration.PercentPerStack)
			task.delay(15 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				local Stacks2 = Unit:GetAttribute("IceFrenzyStacks")
				Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")+Passive.configuration.PercentPerStack)
				Unit:SetAttribute("IceFrenzyStacks", Stacks2-1)
			end)
		end
	end,
}

return Passive
