local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Power Roll II",
	PassiveDescription = "Aira randomly selects one of the following buff pool every 60s (+20% dmg to speed enemies, +20% dmg to flying enemies, +20% dmg to shade enemies)",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		task.spawn(function()

			Unit:SetAttribute("CurrentTypeBuffThing", "")

			local function buff()
				local TypeTable = {"Speedster", "Air", "Shade"}

				if Unit.configuration.CurrentUpgrade.Value < 7 then
					table.remove(TypeTable, 2)
				end
				
				local ChosenType = TypeTable[math.random(1, #TypeTable)]
				local TagName = `{ChosenType == "Air" and "Flying" or ChosenType}Strong`
				local Previous = Unit:GetAttribute("CurrentTypeBuffThing")

				if Previous then
					Unit:RemoveTag(`{Previous == "Air" and "Flying" or Previous}Strong`)
				end

				Unit:AddTag(TagName)
				Unit:SetAttribute("CurrentTypeBuffThing", ChosenType)
			end

			buff()

			while task.wait(60/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value) do
				if not Unit or not Unit.Parent then
					break
				end

				buff()
			end
		end)
	end,
	
	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 and Enemy.Class and Enemy.NPC_Type then
			local CurrType = Unit:GetAttribute("CurrentTypeBuffThing")
			
			local IsClass = Enemy.Class == CurrType or Enemy.NPC_Type == CurrType

			if IsClass then
				return 1.2
			end
		end

		return 1
	end,
}

return Passive
