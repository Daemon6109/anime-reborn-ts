local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Jajanken Mastery",
	PassiveDescription = "Every wave unit switches his power, Rock (15% dmg and 10% crit increase), Paper (20% range but -5% dmg), Scissors (-7.5% spa but -5% range)",
}

Passive.callbacks = {

	onWave = function(self, Unit: Model)
		
		local config = Unit:WaitForChild("configuration", 10)
		local CurrentWave = Unit:GetAttribute("CurrentWaveF") or 0
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local LastPower = Unit:GetAttribute("LastPower")
		local SwitchablePowers = {"Rock", "Paper", "Scissor"}
		
		local Powers = {
			
			["Rock"] = {
				
				Buff = function()
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.15)
					Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+0.1)
				end,
				
				Debuff = function()
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-0.15)
					Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")-0.1)
				end,
				
			},
			
			["Paper"] = {

				Buff = function()
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-0.05)
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.2) 
				end,

				Debuff = function()
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.05)
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")-0.2) 
				end,

			},
			
			["Scissor"] = {

				Buff = function()
					Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.075) 
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")-0.05) 
				end,

				Debuff = function()
					Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")+.075) 
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.05) 
				end,

			},
		};
		
		if LastPower then
			Powers[LastPower].Debuff()
		end
		local NewPower = SwitchablePowers[math.random(1, #SwitchablePowers)]
		Unit:SetAttribute("LastPower", NewPower)
		Powers[NewPower].Buff()
		
	end,

}

return Passive
