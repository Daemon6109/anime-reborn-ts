local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "West City III",
	Description = "Reach at least wave 50 in the infinite mode of West City.",
	PointsNeeded = 50, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite West City", --used for bulk point giving
	Available = true,
	Image = "18564611688",

	Order = 3,

	Reward = {
		Currencies = {
			Gems = 400,
		},

		Items = {
			["TraitCrystal"] = 1,
			["FrostKey"] = 1
		},

		Units = {},
	},
	
	QuestToGiveAfter = nil
}

return module
