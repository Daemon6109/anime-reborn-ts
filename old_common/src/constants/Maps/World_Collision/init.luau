local PlaceIdTab = {
	["17046374415"] = 124019964861837,
	["132521906070053"] = 124019964861837,
	["87542414930759"] = 96932798132908,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "World Collision",
	Icon = "rbxassetid://81759072017786",
	Root = script,
}