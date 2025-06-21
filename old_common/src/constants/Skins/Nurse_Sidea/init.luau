local skin = {}

skin.configuration = {
	Name = script.Name,
	DisplayName = "Nurse Sidea",
	UnitNames = {
		["Esdeath"] = true,
		["Esdeath [Evo]"] = true,
	},
	SkinVFX = {
		["Frost Slashes"] = "Frost Slashes [Valentines]",	
		["Ice Strike"] = "Ice Strike [Valentines]",
		["Icicle Barrage"] = "Icicle Barrage [Valentines]",
		["Ice Meteor"] = "Ice Meteor [Valentines]",
	},
	Rarity = "Secret",
}

skin.misc = {
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"), -- in case we want skins to change on shiny
}

return skin