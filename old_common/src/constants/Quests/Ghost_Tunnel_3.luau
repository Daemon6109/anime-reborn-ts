local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Beat Ghost Tunnel Act 3",
	Description = "Defeat the boss of Ghost Tunnel act 3 and finish the act!",
	PointsNeeded = 1, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Story", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "", --used for bulk point giving
	Available = true,
	Image = "95317581428682",

	Order = 3,

	Reward = {
		Currencies = {
			Gems = 50,
			Gold = 100
		},

		Items = {	},

		Units = {},
	},
	
	QuestToGiveAfter = nil
}

return module
