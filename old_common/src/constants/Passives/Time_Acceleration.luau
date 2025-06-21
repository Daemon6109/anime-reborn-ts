local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Time Acceleration",
	PassiveDescription = "All units in range get -10% SPA buff.",
	--PassiveDescription = "This unit decreases 1 random unit in his radius SPA by 15% for 10 seconds every 15 seconds",
	
	--BuffData = {
	--	AttackSpeed = .15, -- %s
	--},
	--Duration = 10
	
	PercentIncrease = .1,
} 

Passive.callbacks = {
	onUnitsInRange = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitIndividualID = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			local HasBuff = UnitToCheck:GetAttribute("JuliusAccelerationBuff")

			if not HasBuff and IsInRange and UnitToCheck:GetAttribute("JuliusAccelerationId") == nil then
				UnitToCheck:SetAttribute("JuliusAccelerationId", UnitIndividualID)
				UnitToCheck:SetAttribute("JuliusAccelerationBuff", IsInRange)
				UnitToCheck:SetAttribute("PermanentAttackSpeedMulti", UnitToCheck:GetAttribute("PermanentAttackSpeedMulti")-Passive.configuration.PercentIncrease)
			end
		end
	end,

	onRemove = function(self, Unit: Model)
		local UnitIndividualID = Unit:GetAttribute("IUUID")

		for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck:GetAttribute("JuliusAccelerationBuff") == true and UnitToCheck:GetAttribute("JuliusAccelerationId") == UnitIndividualID then
				UnitToCheck:SetAttribute("JuliusAccelerationBuff", false)
				UnitToCheck:SetAttribute("JuliusAccelerationId", nil)
				UnitToCheck:SetAttribute("PermanentAttackSpeedMulti", UnitToCheck:GetAttribute("PermanentAttackSpeedMulti")+Passive.configuration.PercentIncrease)
			end
		end
	end,
	
	--onPlace = function(self: {any}, Unit: Model)
	--	task.spawn(function()
	--		local BuffLib = require(replicated.Libs.BuffLib)
	--		local FastVector = require(replicated.Libs.FastVector).new()
	--		local TempBuff = require(replicated.Libs.TemporaryBuffAPI)
			
	--		local UnitIndividualID = Unit:GetAttribute("IUUID")

	--		while task.wait(15) do
	--			if not Unit or not Unit.Parent then
	--				return
	--			end
				
	--			local Table = {}
				
	--			for _, UnitToCheck in workspace.UnitsPlaced:GetChildren() do
	--				if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
	--					continue
	--				end
					
	--				local UnitRange = BuffLib:GetRangeScaled(Unit)
	--				local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

	--				if IsInRange then
	--					table.insert(Table, UnitToCheck)
	--				end
	--			end
				
	--			if #Table ~= 0 then
	--				TempBuff:ApplyBuff(Table[math.random(1,#Table)], Passive.configuration.BuffData, Passive.configuration.Duration)
	--			end
	--		end
	--	end)
	--end,
}

return Passive
