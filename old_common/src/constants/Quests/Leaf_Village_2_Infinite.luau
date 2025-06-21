local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Leaf Village II",
	Description = "Reach at least wave 25 in the infinite mode of Leaf Village",
	PointsNeeded = 25, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Leaf Village", --used for bulk point giving
	Available = true,
	Image = "18784278567",

	Order = 5,

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
