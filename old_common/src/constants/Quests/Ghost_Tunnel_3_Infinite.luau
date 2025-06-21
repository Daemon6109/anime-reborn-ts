local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Ghost Tunnel III",
	Description = "Reach at least wave 50 in the infinite mode of Ghost Tunnel.",
	PointsNeeded = 50, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Ghost Tunnel", --used for bulk point giving
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
