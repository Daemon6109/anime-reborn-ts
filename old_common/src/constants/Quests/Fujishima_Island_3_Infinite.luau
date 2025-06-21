local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Fujishima Island III",
	Description = "Reach at least wave 50 in the infinite mode of Fujishima Island.",
	PointsNeeded = 50, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Fujishima Island", --used for bulk point giving
	Available = true,
	Image = "95317581428682",

	Order = 12,

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
