local PlaceIdTab = {
	["17046374415"] = 135343551212174,
	["132521906070053"] = 135343551212174,
	["87542414930759"] = 123105574328859,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Five",
	DMapName = "Fire",
	Icon = "rbxassetid://122850023026787",
	Root = script,
	
	['ElementBuff'] = "Fire",
	['ElementalBuffPercentage'] = 150,
}