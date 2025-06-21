local PlaceIdTab = {
	["17046374415"] = 17895401292,
	["132521906070053"] = 17895401292,
	["87542414930759"] = 135401544426279,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = script.Name,
	Icon = "rbxassetid://18564611688",
	Root = script,
}