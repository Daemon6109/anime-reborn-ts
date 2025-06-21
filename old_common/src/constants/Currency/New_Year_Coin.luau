local Currency = {}

Currency.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "New Year Coin" :: string,
	Description = "Event currency!" :: string,
	Image = "rbxassetid://118764467778787",
	Rarity = "Exclusive" :: string,
	Sort = {"Currency"},
	Order = -6,
	DisplayIconSize = UDim2.fromScale(0.7,0.7),
	Gradient = {
		Color3.new(0, 1, 1),
		Color3.new(0.439216, 1, 0.67451),
		Color3.new(0.752941, 0.470588, 1),
	}	
}

return Currency
