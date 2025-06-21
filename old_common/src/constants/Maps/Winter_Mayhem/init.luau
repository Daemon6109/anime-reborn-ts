local PlaceIdTab = {
	["17046374415"] = 71323911886796,
	["132521906070053"] = 71323911886796,
	["87542414930759"] = 127141231527227,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Winter Mayhem",
	Icon = "rbxassetid://113136986137544",
	Root = script,
}