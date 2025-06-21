local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Land of the Sky I",
	Description = "Reach at least wave 15 in the infinite mode of Land of the Sky.",
	PointsNeeded = 15, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Land of the Sky", --used for bulk point giving
	Available = true,
	Image = "18780638924",

	Order = 7,

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
