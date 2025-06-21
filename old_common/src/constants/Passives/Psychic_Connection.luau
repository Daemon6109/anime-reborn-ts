local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Psychic Connection",
	PassiveDescription = "Every 40s, buffs range of all units named `Oktawalk` in radius by 15% for 5s, 15% chance to stun Oktawalk's for 3s",
	TargetAllyName = "Okarun",
	PercentIncrease = .15,
	TagName = "PsychicConnection",
} 

Passive.callbacks = {
	--onUnitsInRange = function(self, Unit: Model)
	--	local BuffLib = require(replicated.Libs.BuffLib)
	--	local FastVector = require(replicated.Libs.FastVector).new()
	--	local UnitRange = BuffLib:GetRangeScaled(Unit)
	--	local UnitIndividualID = Unit:GetAttribute("IUUID")
	--	local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		
	--	local UnitInRange = false
	
	--	for _, UnitToCheck in CurrentlyPlaced do
	--		if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
	--			continue
	--		end

	--		local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange
			
	--		if IsInRange and string.match(UnitToCheck.Name, Passive.configuration.TargetAllyName) then
	--			UnitInRange = true
	--		end
	--	end
		
	--	if UnitInRange and not Unit:GetAttribute("ConnectionBuff") then
	--		Unit:SetAttribute("ConnectionBuff", true)
	--		Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+.15)
	--		Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.075)
	--		return
	--	end
			
	--	if not UnitInRange and Unit:GetAttribute("ConnectionBuff") then
	--		Unit:SetAttribute("ConnectionBuff", false)
	--		Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")-.15)
	--		Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")+.075)
	--	end
	--end,
	onPlace = function(self, Unit: Model)
		task.spawn(function()
			local BuffLib = require(replicated.Libs.BuffLib)
			local FastVector = require(replicated.Libs.FastVector).new()
			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local Collection = game:GetService("CollectionService")
			local IUUID = Unit:GetAttribute("IUUID")

			local function Buff()
				for _, Ally in workspace.UnitsPlaced:GetChildren() do
					if Ally == Unit or not Ally:FindFirstChild("HumanoidRootPart") then
						continue
					end

					local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, Ally.HumanoidRootPart.Position) <= UnitRange

					if string.match(Ally.Name, Passive.configuration.TargetAllyName) and IsInRange then
						if math.random(1, 100) <= 15 then
							_G.UnitAPI:SetTimedStunnedState(Ally, 3)
							continue
						end

						if not Ally:HasTag(Passive.configuration.TagName) then
							Ally:AddTag(Passive.configuration.TagName)
							Ally:SetAttribute(`{Passive.configuration.TagName}Source`, IUUID)
							Ally:SetAttribute("PermanentRangeMulti", Ally:GetAttribute("PermanentRangeMulti")+Passive.configuration.PercentIncrease)
						end
					end
				end

				task.delay(5/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
					for _, Ally in Collection:GetTagged(Passive.configuration.TagName) do
						if Ally:GetAttribute(`{Passive.configuration.TagName}Source`) == IUUID then
							Ally:RemoveTag(Passive.configuration.TagName)
							Ally:SetAttribute(`{Passive.configuration.TagName}Source`, nil)
							Ally:SetAttribute("PermanentRangeMulti", Ally:GetAttribute("PermanentRangeMulti")-Passive.configuration.PercentIncrease)
						end
					end
				end)
			end

			Buff()

			while task.wait(40/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value) do
				Buff()
			end
		end)
	end,
	onRemove = function(self, Unit: Model)
		local Collection = game:GetService("CollectionService")
		local IUUID = Unit:GetAttribute("IUUID")

		for _, Ally in Collection:GetTagged(Passive.configuration.TagName) do
			if Ally:GetAttribute(`{Passive.configuration.TagName}Source`) == IUUID then
				Ally:RemoveTag(Passive.configuration.TagName)
				Ally:SetAttribute(`{Passive.configuration.TagName}Source`, nil)
				Ally:SetAttribute("PermanentRangeMulti", Ally:GetAttribute("PermanentRangeMulti")-Passive.configuration.PercentIncrease)
			end
		end
	end,
}

return Passive
