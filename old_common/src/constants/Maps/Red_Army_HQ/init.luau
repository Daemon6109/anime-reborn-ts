local PlaceIdTab = {
	["17046374415"] = 108408425375836,
	["132521906070053"] = 108408425375836,
	["87542414930759"] = 109086086089233,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Red Army HQ",
	Icon = "rbxassetid://132799298231501",
	Root = script,
}