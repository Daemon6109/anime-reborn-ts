local PlaceIdTab = {
	["17046374415"] = 106842511199068,
	["132521906070053"] = 106842511199068,
	["87542414930759"] = 90339111577891,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Ghost Tunnel",
	Icon = "rbxassetid://104728217409044",
	Root = script,
}