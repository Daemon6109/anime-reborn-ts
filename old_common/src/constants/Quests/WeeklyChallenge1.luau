local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Weekly Challenge I",
	Description = "Clear at least 10 challenges.",
	PointsNeeded = 10, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Weekly", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Challenges", --used for bulk point giving
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
