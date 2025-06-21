local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "West City II",
	Description = "Reach at least wave 25 in the infinite mode of West City.",
	PointsNeeded = 25, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite West City", --used for bulk point giving
	Available = true,
	Image = "18564611688",

	Order = 2,

	Reward = {
		Currencies = {
			Gems = 250,
		},

		Items = {

		},

		Units = {},
	},
	
	QuestToGiveAfter = nil
}

return module
