local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Critical Tempo",
	PassiveDescription = "On Each Kill, Increases Critical Chance by 0.5%, Upto 25%.",
}

Passive.callbacks = {

	onKill = function(self: {any}, Unit: Model, Enemy: {any}?)
		local AddedCrit = Unit:GetAttribute("AddedCriticalChance") or 0
		if AddedCrit < 0.25 then
			Unit:SetAttribute("AddedCriticalChance", AddedCrit + 0.005)
			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance") + 0.005)
		end
	end,
}

return Passive
