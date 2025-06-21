local Challenge = {
	DisplayName = "x1.5 Prices",
}

function Challenge:OnGameLoad()
	game:GetService("ReplicatedStorage"):WaitForChild("GameVariables"):WaitForChild("PriceMultiplier").Value += .5
end

return Challenge
