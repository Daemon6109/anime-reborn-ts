local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Off White",
	PassiveDescription = "When stunned, unit becomes temporarily immune to stun and does +50% Damage for the next 5 seconds "
} 

Passive.callbacks = {

	onStunEnded = function(self, Unit: Model)

		local IsBuffed = Unit:GetAttribute("IsBuffedDoffy")
		if not IsBuffed then
			Unit:SetAttribute("IsBuffedDoffy", true)
			Unit:AddTag("InnateNoStun")
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.5)
			task.delay(5/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:RemoveTag("InnateNoStun")
				Unit:SetAttribute("IsBuffedDoffy", false)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-0.5)
			end)
		end

	end,

}

return Passive
