local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Will of Thunder",
	PassiveDescription = "Whenever Lucky recovers from stun, he gains +25% DMG and -10% SPA for 20 seconds (non-stackable)",
} 

Passive.callbacks = {
	onStunEnded = function(self, Unit: Model)
		local HasBuff = Unit:GetAttribute("WillOfThunderBuff")

		if not HasBuff then
			local BuffUID = game.HttpService:GenerateGUID(false)
			Unit:SetAttribute("WillOfThunderBuffUID", BuffUID)
			Unit:SetAttribute("WillOfThunderBuff", true)

			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+.2)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.1)

			task.delay(20/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute("WillOfThunderBuffUID", nil)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-.2)
				Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")+.1)
				Unit:SetAttribute("WillOfThunderBuff", false)
			end)
		end
	end,
}

return Passive