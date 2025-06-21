local module = {
	GiveItem = "Suit";
	DisplayName = "Suit";
	LayoutOrder = 2;

	Requirements = {
		Items = {
			["BlueStar"] = 1,
			["GreenStar"] = 1,
			["RedStar"] = 1,
		--	["PurpleStar"] = 4,
			["OrangeStar"] = 12,
		--	["RainbowStar"] = 1,
			["Crystals"] = 1250
		};

		Gold = 2500;
	}
}

return module
