local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Beat Fujishima Island Act 6",
	Description = "Defeat the boss of Fujishima Island act 6 and finish the act!",
	PointsNeeded = 1, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Story", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "", --used for bulk point giving
	Available = true,
	Image = "95317581428682",

	Order = 6,

	Reward = {
		Currencies = {
			Gems = 150,
			Gold = 100
		},

		Items = {},

		Units = {},
	},
	
	QuestToGiveAfter = nil
}

return module
