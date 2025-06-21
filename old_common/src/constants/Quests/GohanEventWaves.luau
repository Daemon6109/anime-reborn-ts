local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Red army waves",
	Description = "Play 500 waves on Red Army HQ.",
	PointsNeeded = 500, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Event", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "", --used for bulk point giving
	Available = true,
	Image = "132799298231501",

	EventType = "Gohan",

	Order = -1,
	
	Reward = {
		Currencies = {
			["Red Ticket"] = 500,
		},

		Items = {},

		Units = {},

		BattlepassExp = 500
	},
	
	QuestToGiveAfter = nil
}

return module
