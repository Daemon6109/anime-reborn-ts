local Challenge = {
	DisplayName = "x0.5 Range",
}

function Challenge:OnGameLoad()
	game:GetService("ReplicatedStorage"):WaitForChild("GameVariables"):WaitForChild("GlobalUnitBuffs"):WaitForChild("PermanentRangeMulti").Value -= .5
end

return Challenge
