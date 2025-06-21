local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Brotherhood",
	PassiveDescription = "Whenever Captain Yamo is within Osta's range - Osta gains +20% DMG and -5% SPA (non-stackable)",
	TargetAllyName = "Captain Yami",
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		
		local YamiInRange = false
	
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			
			if IsInRange and string.match(UnitToCheck.Name, Passive.configuration.TargetAllyName) then
				YamiInRange = true
			end
		end
		
		if YamiInRange and not Unit:GetAttribute("BrotherhoodBuff") then
			Unit:SetAttribute("BrotherhoodBuff", true)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+.2)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.05)
			return
		end
			
		if not YamiInRange and Unit:GetAttribute("BrotherhoodBuff") then
			Unit:SetAttribute("BrotherhoodBuff", false)
			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-.2)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")+.05)
		end
	end,
}

return Passive
