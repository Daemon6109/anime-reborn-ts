local PlaceIdTab = {
	["17046374415"] = 96158374524375,
	["132521906070053"] = 96158374524375,
	["87542414930759"] = 81694971106525,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Clover Kingdom",
	Icon = "rbxassetid://94252223594193",
	Root = script,
}