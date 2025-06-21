local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Red Army HQ III",
	Description = "Reach at least wave 50 in the infinite mode of Red Army HQ.",
	PointsNeeded = 50, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Red Army HQ", --used for bulk point giving
	Available = true,
	Image = "132799298231501",

	Order = 15,

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
