local PlaceIdTab = {
	["17046374415"] = 112065128804050,
	["132521906070053"] = 112065128804050,
	["87542414930759"] = 72604274959407,
}

return {
	PlaceId = PlaceIdTab[tostring(game.PlaceId)] or game.PlaceId,
	DisplayName = "Ancient Dungeon",
	Icon = "rbxassetid://92335372221769",
	Root = script,
}