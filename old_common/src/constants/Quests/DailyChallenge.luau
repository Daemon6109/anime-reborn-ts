local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Challenge I",
	Description = "Clear 2 challenges.",
	PointsNeeded = 2, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Daily", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Challenges", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 100,
		},

		Items = {},

		Units = {},
		
		BattlepassExp = 150
	},
	
	QuestToGiveAfter = nil
}

return module
