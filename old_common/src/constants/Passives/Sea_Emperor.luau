local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Sea Emperor",
	PassiveDescription = "+0.5% DMG, Range, SPA each wave up to 5% boosts",
	MaxPassiveStacks = 10,
	PercentPerStack = 0.005,
} 

Passive.callbacks = {
	onWave = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		local ToBuff = {"Damage", "Range", "AttackSpeed"}
		local KaidoSeaEmperorStacks = Unit:GetAttribute("KaidoSeaEmperorStacks") or 0
		
		if KaidoSeaEmperorStacks < Passive.configuration.MaxPassiveStacks then
			Unit:SetAttribute("KaidoSeaEmperorStacks", KaidoSeaEmperorStacks+1)
			
			for _, StatName in ToBuff do
				local CurrentBuff = Unit:GetAttribute(`Permanent{StatName}Multi`)

				if CurrentBuff then
					if StatName == "AttackSpeed" then
						Unit:SetAttribute(`Permanent{StatName}Multi`, CurrentBuff-Passive.configuration.PercentPerStack)
						continue
					end
					Unit:SetAttribute(`Permanent{StatName}Multi`, CurrentBuff+Passive.configuration.PercentPerStack)
				end
			end
		end
	end,
}

return Passive
