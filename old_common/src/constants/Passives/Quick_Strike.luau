local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure
local BuffLib
local FastVector

Passive.configuration = {
	PassiveName = "Quick Strike",
	PassiveDescription = "This unit deals double damage to the closest enemy",
} 

Passive.callbacks = {
	onAttack = function(self, Unit:Model)
		if not BuffLib then
			BuffLib = require(replicated.Libs.BuffLib)
		end

		if not FastVector then
			FastVector = require(replicated.Libs.FastVector).new()
		end
		
		Unit:SetAttribute("ClosestEnemyID", nil)
		Unit:SetAttribute("ClosestEnemyDistance", 999999)
		
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		
		for index, EnemyConstruct in pairs(_G.Constructs) do
			if EnemyConstruct then
				local Distance = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, EnemyConstruct["Position"])
				local IsInRange = Distance <= UnitRange
				
				if IsInRange and Distance < Unit:GetAttribute("ClosestEnemyDistance") then
					Unit:SetAttribute("ClosestEnemyID", index)
					Unit:SetAttribute("ClosestEnemyDistance", Distance)
				end
			end
		end
	end,
	
	onConditionalDamage = function(self, Unit:Model, Enemy:{any}?)
		if not BuffLib then
			BuffLib = require(replicated.Libs.BuffLib)
		end

		if not FastVector then
			FastVector = require(replicated.Libs.FastVector).new()
		end

		if Enemy.EnemyID == Unit:GetAttribute("ClosestEnemyID") then
			return 2
		end
		
		return 1
	end,
}

return Passive
