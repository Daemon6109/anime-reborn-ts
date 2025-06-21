local PlaceIdTab = {
	["17046374415"] = 77796883803017,
	["132521906070053"] = 77796883803017,
	["87542414930759"] = 84261006657471,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = script.Name,
	Icon = "rbxassetid://104590776966225",
	Root = script,
}