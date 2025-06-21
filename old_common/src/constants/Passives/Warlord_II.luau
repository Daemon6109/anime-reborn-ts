--local replicated = game:GetService("ReplicatedStorage")
--local Enums = require(replicated.Libs.Enums)
--local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

--Passive.configuration = {
--	PassiveName = "Warlord",
--	PassiveDescription = "Increases Hawk Eye's critical attack chance by 25%",
--	PercentIncrease = .25,
--} 

--Passive.callbacks = {
--	onPlace = function(self, Unit: Model)
--		local config = Unit:WaitForChild("configuration", 10)
		
--		if config then
--			Unit:SetAttribute("PermanentAttackCriticalChance", Unit:GetAttribute("PermanentAttackCriticalChance")+Passive.configuration.PercentIncrease) 
--		end
--	end,
--}

--return Passive

local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Warlord II",
	PassiveDescription = "Deals +250% more damage to bosses",
	PercentIncrease = 2.5,
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)

		if config then
			Unit:SetAttribute("PermanentDmgToBossMulti", Unit:GetAttribute("PermanentDmgToBossMulti")+Passive.configuration.PercentIncrease) 
		end
	end,
}

return Passive
