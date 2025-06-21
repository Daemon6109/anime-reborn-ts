local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Capsule opening",
	Description = "Open 200 exclusive Event Capsules",
	PointsNeeded = 200, --0 = free
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

		BattlepassExp = 400
	},
	
	QuestToGiveAfter = nil
}

return module
