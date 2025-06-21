local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Hitman Tricks",
	PassiveDescription = "Applies special DoT effect dealing 5% of this unit damage, if enemy was eliminated by the effect, unit gets 2.5% DoT damage buff, resets every 3rd wave",
} 

Passive.callbacks = {
	onWave = function(self, Unit:Model)
		local Stacks = Unit:GetAttribute("HitmanTricksWave") or 0
		
		if Stacks >= 3 then
			Stacks = 0
			
			local DoTStacks = Unit:GetAttribute("HitmanTricksStacks") or 0
			
			Unit.configuration.AttackEffectDamageMultiplier.Value -= .025*DoTStacks
			
			Unit:SetAttribute("HitmanTricksStacks", 0)
			
		end
		
		Unit:SetAttribute("HitmanTricksWave", Stacks+1)
	end,
}

return Passive
