local PlaceIdTab = {
	["17046374415"] = 135343551212174,
	["132521906070053"] = 135343551212174,
	["87542414930759"] = 123105574328859,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Two",
	DMapName = "Water",
	Icon = "rbxassetid://98701196834187",
	Root = script,
	
	['ElementBuff'] = "Water",
	['ElementalBuffPercentage'] = 150,
}