local module = {
	GiveItem = "Shadow Protector";
	DisplayName = "Shadow Protector";
	LayoutOrder = 2;

	Requirements = {
		Items = {
			["BlueStar"] = 1,
			["GreenStar"] = 2,
			["RedStar"] = 1,
			["OrangeStar"] = 15,
			["PurpleStar"] = 3,
		--	["RainbowStar"] = 2,
			["Crystals"] = 2000
		};

		Gold = 5000;
	}
}

return module
