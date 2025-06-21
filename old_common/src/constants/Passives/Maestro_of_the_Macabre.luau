local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Maestro of the Macabre",
	PassiveDescription = "At the start off each wave , grants all `ICE` element allies a 2% attack dmg and 3% range stacking up to 10% dmg and 15% range. every 10th buff wave, buff resets.",
}

Passive.callbacks = {

	onWave = function(self, Unit: Model)
		local config = Unit:WaitForChild("configuration", 10)
		local CurrentWave = Unit:GetAttribute("CurrentWaveF") or 0
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()
		local UnitIndividualID = Unit:GetAttribute("IUUID")

		Unit:SetAttribute("CurrentWaveF", CurrentWave+1)

		for _, UnitToCheck in CurrentlyPlaced do

			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck.configuration.Element.Value == "Ice" then
				local MaestroStacks = UnitToCheck:GetAttribute("MaestroStacks") or 0

				if not UnitToCheck:GetAttribute("MaestroBuff") then
					UnitToCheck:SetAttribute("MaestroBuffID", UnitIndividualID)
					UnitToCheck:SetAttribute("MaestroBuff", true)
				end

				if UnitToCheck:GetAttribute("MaestroBuffID") == UnitIndividualID then
					if MaestroStacks < 5 then
						UnitToCheck:SetAttribute("MaestroStacks", MaestroStacks+1)

						local CurrentBuff = UnitToCheck:GetAttribute(`PermanentDamageMulti`)
						local CurrentBuff2 = UnitToCheck:GetAttribute(`PermanentRangeMulti`)

						local BuffAmount = UnitToCheck:GetAttribute(`BuffAmount`) or 0
						local BuffAmount2 = UnitToCheck:GetAttribute(`BuffAmount2`) or 0

						if CurrentBuff then
							UnitToCheck:SetAttribute(`PermanentDamageMulti`, CurrentBuff+0.02)
							UnitToCheck:SetAttribute(`BuffAmount`, BuffAmount+0.02)
						end
						if CurrentBuff2 then
							UnitToCheck:SetAttribute(`PermanentRangeMulti`, CurrentBuff2+0.03)
							UnitToCheck:SetAttribute(`BuffAmount2`, BuffAmount2+0.03)
						end
					end
				end
			end

		end

		if CurrentWave == 10 then
			Unit:SetAttribute("CurrentWaveF", 0)
			for _, UnitToCheck in CurrentlyPlaced do

				if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
					continue
				end

				if UnitToCheck.configuration.Element.Value == "Ice" then

					local CurrentBuff = UnitToCheck:GetAttribute(`PermanentDamageMulti`)
					local CurrentBuff2 = UnitToCheck:GetAttribute(`PermanentRangeMulti`)

					local BuffAmount = UnitToCheck:GetAttribute(`BuffAmount`) or 0
					local BuffAmount2 = UnitToCheck:GetAttribute(`BuffAmount2`) or 0

					if CurrentBuff then
						UnitToCheck:SetAttribute(`PermanentDamageMulti`, CurrentBuff-BuffAmount)
						UnitToCheck:SetAttribute(`BuffAmount`, 0)
					end
					if CurrentBuff2 then
						UnitToCheck:SetAttribute(`PermanentRangeMulti`, CurrentBuff2-BuffAmount2)
						UnitToCheck:SetAttribute(`BuffAmount2`, 0)
					end

					UnitToCheck:SetAttribute("MaestroStacks", 0)

				end
			end
		end

	end,


	onRemove = function(self, Unit: Model)

		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		for _, UnitToCheck in CurrentlyPlaced do

			if not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			if UnitToCheck.configuration.Element.Value == "Water" then
				if UnitToCheck:GetAttribute("MaestroBuffID") == UnitIndividualID then

					UnitToCheck:SetAttribute("MaestroBuffID", nil)
					UnitToCheck:SetAttribute("MaestroBuff", false)

					local CurrentBuff = UnitToCheck:GetAttribute(`PermanentDamageMulti`)
					local CurrentBuff2 = UnitToCheck:GetAttribute(`PermanentRangeMulti`)

					local BuffAmount = UnitToCheck:GetAttribute(`BuffAmount`) or 0
					local BuffAmount2 = UnitToCheck:GetAttribute(`BuffAmount2`) or 0

					if CurrentBuff then
						UnitToCheck:SetAttribute(`PermanentDamageMulti`, CurrentBuff-BuffAmount)
						UnitToCheck:SetAttribute(`BuffAmount`, 0)
					end
					if CurrentBuff2 then
						UnitToCheck:SetAttribute(`PermanentRangeMulti`, CurrentBuff2-BuffAmount2)
						UnitToCheck:SetAttribute(`BuffAmount2`, 0)
					end

					UnitToCheck:SetAttribute("MaestroStacks", 0)
				end
			end
		end

	end,

}

return Passive
