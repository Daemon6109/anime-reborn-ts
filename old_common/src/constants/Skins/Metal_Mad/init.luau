local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Metal (Mad)",
	UnitNames = {
		["Iron"] = true,
		["Iron [Evo]"] = true,
		["Iron [Evo2]"] = true
	},
	SkinVFX = {},
	Rarity = "Epic",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin