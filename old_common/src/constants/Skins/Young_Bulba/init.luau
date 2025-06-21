local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Young Bulba",
	UnitNames = {
		["Bulma"] = true,
	},
	SkinVFX = {
		["House"] = "FirstBuilding Valentines",	
		["Laboratory"] = "SecondBuilding Valentines",
		["Tower"] = "ThirdBuilding Valentines",
		["Capsule Corp"] = "Capsule Corp Valentines",
	},
	Rarity = "Epic",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin