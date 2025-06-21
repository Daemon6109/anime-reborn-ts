local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Cero Doble",
	PassiveDescription = "Every 5 hits, her next attack will have 100% crit chance + 100% crit damage, She also has stun immunity on placement."
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag("InnateNonTarget")
		Unit:AddTag("InnateNoStun")
	end,
	onAttack = function(self, Unit: Model)
		local CeroDobleStacks = Unit:GetAttribute("CeroDobleStacks") or 0

		if not Unit:GetAttribute("CeroDobleBuff") then
			Unit:SetAttribute("CeroDobleStacks", CeroDobleStacks+1)
			
			if Unit:GetAttribute("CeroDobleStacks") >= 5 then
				Unit:SetAttribute("CeroDobleBuff", true)
				Unit:SetAttribute("CeroDobleStacks", 0)
			end
		end
	end,
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Unit:GetAttribute("CeroDobleBuff") then
			warn("Okay. should crit and have 100% more thing")
			return 1, true, 1
		end

		return 1
	end,
	onAttackEnded = function(self, Unit: Model)
		if Unit:GetAttribute("CeroDobleBuff") then
			Unit:setAttribute("CeroDobleBuff", nil) 
		end
	end,
}

return Passive
