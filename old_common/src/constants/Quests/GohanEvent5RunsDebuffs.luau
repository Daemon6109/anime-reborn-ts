local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Red army perfect raid",
	Description = "Complete 3 Red army HQ games with only debuffs.",
	PointsNeeded = 3, --0 = free
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
