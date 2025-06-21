local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Book (Elite)",
	UnitNames = {
		["Baek YoonHo"] = true,
		["Baek YoonHo [Evo]"] = true
	},
	SkinVFX = {},
	Rarity = "Legendary",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin