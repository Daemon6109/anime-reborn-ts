local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Daily Summons II",
	Description = "Summon 20 units.",
	PointsNeeded = 20, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Daily", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Summons", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 150,
		},

		Items = {},

		Units = {},

		BattlepassExp = 150
	},
	
	QuestToGiveAfter = nil
}

return module
