local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Power Link",
	PassiveDescription = "This unit links with the 2 strongest units in range, getting +5% of their damages",
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
	
		if Unit:GetAttribute("ExtraDamage1") then
			Unit.configuration.Damage.Value -= Unit:GetAttribute("ExtraDamage1")
			Unit:SetAttribute("ExtraDamage1", 0)
		end
		
		if Unit:GetAttribute("ExtraDamage2") then
			Unit.configuration.Damage.Value -= Unit:GetAttribute("ExtraDamage2")
			Unit:SetAttribute("ExtraDamage2", 0)
		end
	
		local Damages = {}
	
		for _, UnitToCheck:Model in CurrentlyPlaced do
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			if UnitToCheck:FindFirstChild("configuration") and UnitToCheck ~= Unit and IsInRange then
				table.insert(Damages, UnitToCheck.configuration.Damage.Value*0.05)
			end
		end
		
		if #Damages ~= 0 then
			for a=1, 2 do
				local CurrChoice = 0
				local ChoiceIndex = 0

				for i,v in pairs(Damages) do
					if CurrChoice < v then
						CurrChoice = v
						ChoiceIndex = i
					end
				end

				table.remove(Damages, ChoiceIndex)

				Unit:SetAttribute(`ExtraDamage{a}`, CurrChoice)

				Unit.configuration.Damage.Value += CurrChoice
				
				if #Damages == 0 then
					break
				end
			end
		end
	end,
}

return Passive
