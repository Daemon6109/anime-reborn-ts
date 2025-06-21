local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Beast Of Love Gohun",
	UnitNames = {
		["Gohan"] = true,
		["Gohan [Beast]"] = true,
	},
	SkinVFX = {
		["Beam Cannon"] = "Beam Cannon [Valentines]",	
		["Energy Beam"] = "Energy Beam [Valentines]",
		["Energy Blast Volley"] = "Energy Blast Volley [Valentines]",
		["Spiral Beast Cannon"] = "Spiral Beast Cannon [Valentines]",
	},
	Rarity = "Exclusive",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin