local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Black Heart",
	PassiveDescription = "Every wave completed, Solo buffs all of his stats by 1.5% - Caps at 50%, Also buffs his summoned shadows' HP by 1.3% every wave - Caps at 40%",
	StatPerWave = 1.5,
	MaxStats = 50 
} 

Passive.callbacks = {
	onWave = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)

		local BlackHeartStacks = Unit:GetAttribute("BlackHeartStacks") or 0

		local MaxStacks = math.floor(Passive.configuration.MaxStats / Passive.configuration.StatPerWave)

		if BlackHeartStacks < MaxStacks then
			Unit:SetAttribute("BlackHeartStacks", BlackHeartStacks + 1)

			for _, StatName in {"Damage", "Range", "AttackSpeed"} do
				local attrName = "Permanent" .. StatName .. "Multi"

				local CurrentBuff = Unit:GetAttribute(attrName) or 1

				local BuffAmount = Passive.configuration.StatPerWave / 100
				
				if StatName == "AttackSpeed" then
					BuffAmount = -BuffAmount
				end

				Unit:SetAttribute(attrName, CurrentBuff + BuffAmount)
			end
		end
	end,
}

return Passive
