local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Cupid Uriu",
	UnitNames = {
		["Uryu"] = true,
	},
	SkinVFX = {
		["Letz Stil"] = "Letz Stil [Valentines]",	
		["Licht Regen"] = "Licht Regen [Valentines]",
	},
	Rarity = "Legendary",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin