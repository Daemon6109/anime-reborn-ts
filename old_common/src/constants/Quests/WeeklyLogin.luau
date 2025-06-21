local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Weekly Login I",
	Description = "Login to the game for 3 Days.",
	PointsNeeded = 3, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Weekly", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Login", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 250,
		},

		Items = {

		},

		Units = {},

		BattlepassExp = 300
	},
	
	QuestToGiveAfter = nil
}

return module
