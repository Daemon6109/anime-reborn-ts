local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Land of the Sky II",
	Description = "Reach at least wave 25 in the infinite mode of Land of the Sky.",
	PointsNeeded = 25, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Land of the Sky", --used for bulk point giving
	Available = true,
	Image = "18780638924",

	Order = 8,

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
