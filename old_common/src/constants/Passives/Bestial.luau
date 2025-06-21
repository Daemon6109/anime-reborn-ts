local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Bestial",
	PassiveDescription = "After 30 eliminations, he gains 35% damage buff + -35% SPA, Lasts for 10s. Cooldown : 60s", -- while stunning all allies in range
	KillsNeeded = 30,
	Duration = 10
}

Passive.callbacks = {
	onKill = function(self, Unit: Model)
		local Stacks = Unit:GetAttribute("BestialStacks") or 0
		local Mode = Unit:GetAttribute("BestialMode") or false
		local OnCD = Unit:GetAttribute("BestialModeCD") or false

		local config = Unit:WaitForChild("configuration", 10)

		if Mode or OnCD or not config then return end

		if Stacks < Passive.configuration.KillsNeeded then
			Unit:SetAttribute("BestialStacks", Stacks + 1)
		else
			Unit:SetAttribute("BestialStacks", 0)
			Unit:SetAttribute("BestialMode", true)

			Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti") + .35)
			Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti") - .35)

			--[[local BuffLib = require(replicated.Libs.BuffLib)
			local FastVector = require(replicated.Libs.FastVector).new()
			local UnitRange = BuffLib:GetRangeScaled(Unit)
			local UnitIndividualID = Unit:GetAttribute("IUUID")
			local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
			
			for _, UnitToCheck in CurrentlyPlaced do
				if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
					continue
				end

				local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

				if IsInRange then
					UnitToCheck:AddTag("Stunned")
					UnitToCheck:SetAttribute("NextStunPossibleAt", tick()+Passive.configuration.Duration)

					task.delay(Passive.configuration.Duration, function()
						UnitToCheck:RemoveTag("Stunned")
					end)
				end
			end]]
			
			task.delay(Passive.configuration.Duration / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				Unit:SetAttribute("BestialMode", false)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti") - .35)
				Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti") + .35)

				Unit:SetAttribute("BestialModeCD", true)

				task.wait(60 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)

				Unit:SetAttribute("BestialModeCD", nil)
			end)
		end
	end,
}

return Passive
