local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "All event quests",
	Description = "Complete all event quests.",
	PointsNeeded = 6, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Event", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "GohanAll", --used for bulk point giving
	Available = true,
	Image = "132799298231501",

	EventType = "Gohan",

	Order = -2,
	
	Reward = {
		Currencies = {
			["Red Ticket"] = 5000,
		},

		Items = {},

		Units = {},

		BattlepassExp = 1000
	},
	
	QuestToGiveAfter = nil
}

return module
