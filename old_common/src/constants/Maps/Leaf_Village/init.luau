local PlaceIdTab = {
	["17046374415"] = 18784000534,
	["132521906070053"] = 18784000534,
	["87542414930759"] = 97927063638403,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = script.Name,
	Icon = "rbxassetid://18784278567",
	Root = script,
}