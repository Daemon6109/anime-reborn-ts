local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Daily Summons III",
	Description = "Summon 25 units.",
	PointsNeeded = 25, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Daily", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Summons", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 200,
		},

		Items = {},

		Units = {},

		BattlepassExp = 150
	},
	
	QuestToGiveAfter = nil
}

return module
