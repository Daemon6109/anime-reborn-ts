local module = {
	GiveItem = "Sword Shield";
	DisplayName = "Sword Shield";
	LayoutOrder = 2;

	Requirements = {
		Items = {
			["BlueStar"] = 1,
			["GreenStar"] = 3,
			["RedStar"] = 2,
			["OrangeStar"] = 13,
			["PurpleStar"] = 1,
		--	["RainbowStar"] = 1,
			["Crystals"] = 2000
		};

		Gold = 5000;
	}
}

return module
