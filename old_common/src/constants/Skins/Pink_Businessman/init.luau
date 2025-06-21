local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Pink Businessman",
	UnitNames = {
		["Speedwagon"] = true,
	},
	SkinVFX = {
		["Oil Rig"] = "Oil Rig [Pink]",	
		["Factory"] = "Factory [Pink]",
		["Conglomerate"] = "Conglomerate [Pink]",
	},
	Rarity = "Legendary",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin