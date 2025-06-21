local PlaceIdTab = {
	["17046374415"] = 135343551212174,
	["132521906070053"] = 135343551212174,
	["87542414930759"] = 123105574328859,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Three",
	DMapName = "Light",
	Icon = "rbxassetid://128932722282639",
	Root = script,
	
	['ElementBuff'] = "Light",
	['ElementalBuffPercentage'] = 150,
}