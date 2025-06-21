local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Lovely Tuxedo Tin Tin",
	UnitNames = {
		["Ten Ten"] = true,
	},
	Rarity = "Epic",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin