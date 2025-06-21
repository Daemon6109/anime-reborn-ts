local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Careless Acceleration",
	PassiveDescription = "With a 10% chance does 50% more DMG for the attack, but with a 2% chance might get self-stunned for 5 seconds.",
	PercentIncrease = .5,
} 

Passive.callbacks = {
	onAttack = function(self, Unit: Model)
		local Roll = math.random(0, 100)
		
		if Unit:HasTag("CarelessAcceleration") then
			Unit:RemoveTag("CarelessAcceleration")
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-Passive.configuration.PercentIncrease)
		end
		
		if Unit:HasTag("StunOnAttackEnd") then
			Unit:RemoveTag("StunOnAttackEnd")
		end
		
		if Roll <= 2 then
			Unit:AddTag("StunOnAttackEnd")
		end
		
		if Roll <= 12 and Roll > 2 then
			Unit:AddTag("CarelessAcceleration")
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease)
		end
	end,
	onAttackEnded = function(self, Unit: Model)
		if Unit:HasTag("CarelessAcceleration") then
			Unit:RemoveTag("CarelessAcceleration")
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-Passive.configuration.PercentIncrease)
		end
		
		if Unit:HasTag("StunOnAttackEnd") then
			Unit:RemoveTag("StunOnAttackEnd")
			_G.UnitAPI:SetTimedStunnedState(Unit, 5)
		end
	end,
}

return Passive
