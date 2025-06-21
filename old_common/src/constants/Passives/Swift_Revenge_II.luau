local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Swift Revenge II",
	PassiveDescription = "Chisota has a 100% chance to dodge enemy stuns, if she successfully dodges it, her next attack deals +200% more damage (CD 5s)",
	PassiveCooldown = 5,
	PercentIncrease = 2,
	Duration = 1,
	TagName = "SwiftRevenge"
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		if Unit:HasTag(`{Passive.configuration.TagName}Buff`) then
			Unit:RemoveTag(`{Passive.configuration.TagName}Buff`)
			Unit:AddTag(`{Passive.configuration.TagName}Deduct`)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease)
		end
	end,
	onAttackEnded = function(self, Unit: Model)
		if Unit:HasTag(`{Passive.configuration.TagName}Deduct`) then
			Unit:RemoveTag(`{Passive.configuration.TagName}Deduct`)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-Passive.configuration.PercentIncrease)
		end
	end,
	onBeforeStun = function(self, Unit: Model)
		local UnitLastDodge = Unit:GetAttribute(`{Passive.configuration.TagName}LastTick`) or 0
		
		if UnitLastDodge-tick() <= 0 then
			Unit:SetAttribute(`{Passive.configuration.TagName}LastTick`, tick()+Passive.configuration.PassiveCooldown)
			Unit:RemoveTag("ChisotaDodge")
			Unit:AddTag("ChisotaDodge")
			Unit:AddTag("Dodged")
			Unit:AddTag(`{Passive.configuration.TagName}Buff`)
			
			task.delay(Passive.configuration.Duration / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:RemoveTag("Dodged")
			end)	
		end
	end, 
}

return Passive
