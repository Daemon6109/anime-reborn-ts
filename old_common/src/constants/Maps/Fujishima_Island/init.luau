local PlaceIdTab = {
	["17046374415"] = 114706988516358,
	["132521906070053"] = 114706988516358,
	["87542414930759"] = 77727911936233,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Fujishima",
	Icon = "rbxassetid://95317581428682",
	Root = script,
}