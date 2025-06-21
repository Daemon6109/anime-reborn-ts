local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Tusk (Mad)",
	UnitNames = {
		["Kargalgan"] = true,
		["Kargalgan [Evo]"] = true,
		["Kargalgan [Evo2]"] = true
	},
	SkinVFX = {},
	Rarity = "Common",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin