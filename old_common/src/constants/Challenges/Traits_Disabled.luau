local Challenge = {
	DisplayName = "Traits Disabled",
}

function Challenge:OnGameLoad()
	game:GetService("ReplicatedStorage"):WaitForChild("GameVariables"):WaitForChild("TraitsDisabled").Value = true
end

return Challenge
