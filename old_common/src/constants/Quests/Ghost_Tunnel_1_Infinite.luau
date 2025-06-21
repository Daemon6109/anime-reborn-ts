local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Ghost Tunnel I",
	Description = "Reach at least wave 15 in the infinite mode of Ghost Tunnel.",
	PointsNeeded = 15, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Infinite", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite Ghost Tunnel", --used for bulk point giving
	Available = true,
	Image = "95317581428682",
	
	Order = 10,
	
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
