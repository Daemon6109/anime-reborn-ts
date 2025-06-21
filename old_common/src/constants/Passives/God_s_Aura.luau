local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure
local BuffLib
local FastVector

Passive.configuration = {
	PassiveName = "God’s Aura",
	PassiveDescription = "Any enemy that enters this unit's range is slowed by 25% and takes 10% more damage.",
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

				local SpeedPercent = .25

				if not EnemyConstruct.WhisSlowdown and IsInRange then
					if _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID] and _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["MainSlowdown"] then
						_G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["MainSlowdown"] = nil
					end

					local GUID = _G.EnemySpeedManager["AddDirectBooster"]("WhisSlowdown", EnemyConstruct,-EnemyConstruct.OriginalSpeed*SpeedPercent,999999)

					EnemyConstruct.SlowdownImmunity = true
					EnemyConstruct.WhisSlowdown = {GUID, SpeedPercent}
				end

				if EnemyConstruct.WhisSlowdown and not IsInRange then
					--print(EnemyConstruct, "left the zone")
					--_G.EnemySpeedManager["Enemies"][EnemyConstruct][EnemyConstruct.WhisSlowdown] = nil
					_G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["WhisSlowdown"] = nil


					EnemyConstruct.SlowdownImmunity = nil
					EnemyConstruct.WhisSlowdown = nil
				end

				if EnemyConstruct.WhisSlowdown and IsInRange and EnemyConstruct.WhisSlowdown[2] ~= SpeedPercent then
					--print("Change to: "..SpeedPercent)
					if _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID] and _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["MainSlowdown"] then
						_G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["MainSlowdown"] = nil
					end

					local GUID = _G.EnemySpeedManager["AddDirectBooster"]("WhisSlowdown", EnemyConstruct,-EnemyConstruct.OriginalSpeed*SpeedPercent,999999)

					EnemyConstruct.WhisSlowdown = {GUID, SpeedPercent}
				end
			end
		end

		--BuffLib = nil
		--FastVector = nil
	end,

	onRemove = function(self, Unit: Model)
		--print("hey")
		for index, EnemyConstruct in pairs(_G.Constructs) do
			--print(EnemyConstruct.WhisSlowdown)
			if EnemyConstruct.WhisSlowdown then
				if _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID] and _G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["WhisSlowdown"] then
					_G.EnemySpeedManager["Enemies"][EnemyConstruct.EnemyID]["WhisSlowdown"] = nil
				end

				EnemyConstruct.SlowdownImmunity = nil
				EnemyConstruct.WhisSlowdown = nil
			end
		end
	end,

	onConditionalDamage = function(self, Unit: Model, Enemy: {any})
		if Enemy and Enemy.Health > 0 then
			if Unit:GetAttribute("SpecialAbilityUsed") then
				return 1.3
			else
				return 1.1
			end
		end
		return 1
	end,
}

return Passive
