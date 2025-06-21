local Currency = {}

Currency.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "Gold" :: string,
	Description = "Regular currency!" :: string,
	Image = "rbxassetid://18922132513",
	Rarity = "Legendary" :: string,
	Sort = {"Currency"},
	Order = 2,
	DisplayIconSize = UDim2.fromScale(0.7,0.7),
	Gradient = {
		Color3.new(1, 0.615686, 0),
		Color3.new(0.898039, 1, 0),
		Color3.new(1, 0.615686, 0),
		Color3.new(0.898039, 1, 0)
	}
}

return Currency
