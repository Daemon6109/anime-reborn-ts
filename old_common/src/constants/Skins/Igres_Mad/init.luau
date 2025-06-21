local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Igros (Mad)",
	UnitNames = {
		["Igris"] = true,
		["Igris [Evo]"] = true,
		["Igris [Evo2]"] = true
	},
	SkinVFX = {},
	Rarity = "Uncommon",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin