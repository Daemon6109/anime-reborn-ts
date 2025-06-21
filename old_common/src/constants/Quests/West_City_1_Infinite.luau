local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "West City I",
	Description = "Reach at least wave 15 in the infinite mode of West City.",
	PointsNeeded = 15, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite West City", --used for bulk point giving
	Available = true,
	Image = "18564611688",

	Order = 1,

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
