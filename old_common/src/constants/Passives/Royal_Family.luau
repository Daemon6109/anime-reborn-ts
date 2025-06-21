local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Royal Family",
	PassiveDescription = "This unit gets +100% more yen from enemies and bosses",
} 

Passive.callbacks = {

}

return Passive
