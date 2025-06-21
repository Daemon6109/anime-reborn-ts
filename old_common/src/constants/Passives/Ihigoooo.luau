local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Ihigoooo!",
	PassiveDescription = "If placed near an Ihigo, Will have stun immunity for the next 20s",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local CurrentlyPlaced = workspace.UnitsPlaced:GetChildren()

		local IchigoInRange = false

		for _, UnitToCheck in CurrentlyPlaced do
			if UnitToCheck == Unit or not UnitToCheck:FindFirstChild("HumanoidRootPart") then
				continue
			end

			local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, UnitToCheck.HumanoidRootPart.Position) <= UnitRange

			if IsInRange and string.match(UnitToCheck.Name, "Ichigo") then
				IchigoInRange = true
				break
			end
		end

		if IchigoInRange then
			Unit:AddTag("InnateNonTarget")
			Unit:AddTag("InnateNoStun")
			warn("Great stuff, has immunity")
			task.delay(20/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value, function()
				warn("no mooo")
				Unit:RemoveTag("InnateNonTarget")
				Unit:RemoveTag("InnateNoStun")
			end)
		end
	end,
}

return Passive