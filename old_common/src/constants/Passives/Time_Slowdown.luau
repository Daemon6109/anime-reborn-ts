local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure
local BuffLib
local FastVector

Passive.configuration = {
	PassiveName = "Time Slowdown",
	PassiveDescription = "This unit slows down every enemy in range up to 55% depending on how close they are!",
	
	RangeTable = {
		[1] = {60, .05},
		[2] = {50, .15},
		[3] = {30, .25},
		[4] = {25, .33},
		[5] = {15, .45},
		[6] = {10, .55},
	}
} 

Passive.callbacks = {	
	onServerTick = function(self, Unit: Model, Delta: number)
		if not BuffLib then
			BuffLib = require(replicated.Libs.BuffLib)
		end
		
		if not FastVector then
			FastVector = require(replicated.Libs.FastVector).new()
		end
		
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		
		for index, EnemyConstruct in pairs(_G.Constructs) do
			if EnemyConstruct then
				local Distance = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, EnemyConstruct["Position"])
				local IsInRange = Distance <= UnitRange
				
				local SpeedPercent = 0

				for i,v in ipairs(Passive.configuration.RangeTable) do
					if Distance < v[1] then
						SpeedPercent = v[2]
					else
						break
					end
				end

				if not EnemyConstruct.JuliusSlowdown and IsInRange then
					if _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID] and _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["MainSlowdown"] then
						_G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["MainSlowdown"] = nil
					end

					local GUID = _G.EnemySpeedManager["AddDirectBooster"]("JuliusSlowdown", EnemyConstruct,-EnemyConstruct.OriginalSpeed*SpeedPercent,999999)

					EnemyConstruct.SlowdownImmunity = true
					EnemyConstruct.JuliusSlowdown = {GUID, SpeedPercent}
				end

				if EnemyConstruct.JuliusSlowdown and not IsInRange then
					--print(EnemyConstruct, "left the zone")
					--_G.EnemySpeedManager["Enemies"][EnemyConstruct][EnemyConstruct.JuliusSlowdown] = nil
					_G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["JuliusSlowdown"] = nil
					

					EnemyConstruct.SlowdownImmunity = nil
					EnemyConstruct.JuliusSlowdown = nil
				end
				
				if EnemyConstruct.JuliusSlowdown and IsInRange and EnemyConstruct.JuliusSlowdown[2] ~= SpeedPercent then
					--print("Change to: "..SpeedPercent)
					if _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID] and _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["MainSlowdown"] then
						_G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["MainSlowdown"] = nil
					end
					
					local GUID = _G.EnemySpeedManager["AddDirectBooster"]("JuliusSlowdown", EnemyConstruct,-EnemyConstruct.OriginalSpeed*SpeedPercent,999999)

					EnemyConstruct.JuliusSlowdown = {GUID, SpeedPercent}
				end
			end
		end
		
		--BuffLib = nil
		--FastVector = nil
	end,
	
	onRemove = function(self, Unit: Model)
		--print("hey")
		for index, EnemyConstruct in pairs(_G.Constructs) do
			--print(EnemyConstruct.JuliusSlowdown)
			if EnemyConstruct.JuliusSlowdown then
				if _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID] and _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["JuliusSlowdown"] then
					_G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["JuliusSlowdown"] = nil
				end

				EnemyConstruct.SlowdownImmunity = nil
				EnemyConstruct.JuliusSlowdown = nil
			end
		end
	end,
}

return Passive
