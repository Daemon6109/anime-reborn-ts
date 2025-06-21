local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Beat Red Army HQ Act 2",
	Description = "Defeat the boss of Red Army HQ act 2 and finish the act!",
	PointsNeeded = 1, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Story", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "", --used for bulk point giving
	Available = true,
	Image = "132799298231501",

	Order = 2,

	Reward = {
		Currencies = {
			Gems = 50,
			Gold = 100
		},

		Items = {},

		Units = {},
	},
	
	QuestToGiveAfter = nil
}

return module
