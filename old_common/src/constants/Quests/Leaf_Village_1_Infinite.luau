local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Leaf Village I",
	Description = "Reach at least wave 15 in the infinite mode of Leaf Village",
	PointsNeeded = 15, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Leaf Village", --used for bulk point giving
	Available = true,
	Image = "18784278567",

	Order = 4,

	Reward = {
		Currencies = {
			Gems = 75,
		},

		Items = {

		},

		Units = {},
	},
	
	QuestToGiveAfter = nil
}

return module
