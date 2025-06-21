local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Land of the Sky III",
	Description = "Reach at least wave 50 in the infinite mode of Land of the Sky.",
	PointsNeeded = 50, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Land of the Sky", --used for bulk point giving
	Available = true,
	Image = "18780638924",

	Order = 9,

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
