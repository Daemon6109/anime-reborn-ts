local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Heaven's Scar",
	PassiveDescription = "First unit within this unit range get 'scar' effect on all attacks",
	MaxPassiveStacks = 1,
	TagName = "HeavenScar"
} 

-- Unit:SetAttribute("PassiveSlow", false)

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local CurrentStacksInitial = Unit:GetAttribute("HeavenBleedStacks") or 0
		local BuffedCountCheck = 0
		local Targets = {}
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck:GetAttribute("HeavenBleedId") == UnitIndividualID then
				BuffedCountCheck += 1
			end
		end
		
		if CurrentStacksInitial ~= BuffedCountCheck then
			Unit:SetAttribute("HeavenBleedStacks", CurrentStacksInitial+(BuffedCountCheck-CurrentStacksInitial))
		end
		
		local CurrentStacks = Unit:GetAttribute("HeavenBleedStacks") or 0
		
		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local Mag = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position)
			local IsInRange = Mag <= UnitRange
			local BuffDiff = Passive.configuration.PercentIncrease 
			local HasBuff = UnitToCheck:GetAttribute("HeavenBleedBuff")
			local CurrentStacks = Unit:GetAttribute("HeavenBleedStacks") or 0
			
			if not HasBuff and IsInRange and CurrentStacks < Passive.configuration.MaxPassiveStacks then
				table.insert(Targets, {ID = UnitToCheck:GetAttribute("IUUID"), DPS = math.floor((BuffLib:GetDamage(UnitToCheck)/BuffLib:GetAttackSpeed(UnitToCheck))), Mag = Mag})
			end
		end
		
		if #Targets > 0 and CurrentStacks < Passive.configuration.MaxPassiveStacks then
			table.sort(Targets, function(a,b)
				return a.DPS > b.DPS and a.Mag < b.Mag
			end)
			
			for _, Data in Targets do
				local CurrentStacks = Unit:GetAttribute("HeavenBleedStacks") or 0
				
				if CurrentStacks > 0 then
					break
				end
				
				if Data.DPS > 5 then
					for _, UnitToCheck in CurrentlyPlaced do
						if UnitToCheck:GetAttribute("IUUID") == Data.ID then
							Unit:SetAttribute("HeavenBleedStacks", (Unit:GetAttribute("HeavenBleedStacks") or 0)+1)
							UnitToCheck:AddTag(Passive.configuration.TagName)
							UnitToCheck:SetAttribute("HeavenBleedBuff", true)
							UnitToCheck:SetAttribute("HeavenBleedId", Unit:GetAttribute("IUUID"))
							UnitToCheck:SetAttribute("PassiveScar", 5)
							break
						end
					end
				end
			end
		end
		
		Targets = nil
	end,
	
	onRemove = function(self, Unit: Model)
		local UnitIndividualId = Unit:GetAttribute("IUUID")
		
		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end
			
			if UnitToCheck:GetAttribute("HeavenBleedBuff") == true and UnitToCheck:GetAttribute("HeavenBleedId") == UnitIndividualId then
				UnitToCheck:RemoveTag(Passive.configuration.TagName)
				UnitToCheck:SetAttribute("HeavenBleedBuff", false)
				UnitToCheck:SetAttribute("HeavenBleedId", nil)
				UnitToCheck:SetAttribute("PassiveScar", nil)
			end
		end
	end,
}

return Passive
