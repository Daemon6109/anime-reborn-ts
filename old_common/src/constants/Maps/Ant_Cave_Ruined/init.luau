local PlaceIdTab = {
	["17046374415"] = 114119464531079,
	["132521906070053"] = 114119464531079,
	["87542414930759"] = 93576866005602,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = script.Name,
	Icon = "rbxassetid://115574135319292",
	Root = script,
}