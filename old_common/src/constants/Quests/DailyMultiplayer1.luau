local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Multiplayer I",
	Description = "Play at least 15 waves with another player.",
	PointsNeeded = 15, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Daily", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Multiplayer", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 50,
		},

		Items = {

		},

		Units = {},

		BattlepassExp = 150
	},
	
	QuestToGiveAfter = nil
}

return module
