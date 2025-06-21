local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Eminence of Love Cod",
	UnitNames = {
		["Cid"] = true,
		["Cid [Evo]"] = true,
	},
	SkinVFX = {
		["Atomic Strike"] = "Atomic Strike [Valentines]",	
		["Shadow Ambush"] = "Shadow Ambush [Valentines]",
		["Atomic"] = "Atomic [Valentines]",
	},
	Rarity = "Exclusive",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin