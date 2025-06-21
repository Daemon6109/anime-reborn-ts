local PlaceIdTab = {
	["17046374415"] = 18681560853,
	["132521906070053"] = 18681560853,
	["87542414930759"] = 99425886791592,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = script.Name,
	Icon = "rbxassetid://18780638924",
	Root = script,
}