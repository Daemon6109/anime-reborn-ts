local PlaceIdTab = {
	["17046374415"] = 126314489228787,
	["132521906070053"] = 126314489228787,
	["87542414930759"] = 136535516133179,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Soul Desert",
	Icon = "rbxassetid://85655194845638",
	Root = script,
}