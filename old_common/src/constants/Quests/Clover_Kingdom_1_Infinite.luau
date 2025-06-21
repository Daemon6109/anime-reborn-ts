local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Clover Kingdom I",
	Description = "Reach at least wave 15 in the infinite mode of Clover Kingdom.",
	PointsNeeded = 15, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Clover Kingdom", --used for bulk point giving
	Available = true,
	Image = "132799298231501",
	
	Order = 16,
	
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
