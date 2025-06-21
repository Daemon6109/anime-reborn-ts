local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Chef Itaha",
	UnitNames = {
		["Itachi"] = true,
		["Itachi [Susanoo]"] = true,
	},
	SkinVFX = {
		["Fireball Jutsu"] = "Gluttony",
	},
	Rarity = "Rare",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin