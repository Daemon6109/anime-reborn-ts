local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Elimination IV",
	Description = "Get 1000 eliminations from any gamemode.",
	PointsNeeded = 1000, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	QuestType = "Daily", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Eliminations", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 260,
		},

		Items = {
	
		},

		Units = {},

		BattlepassExp = 150
	},
	
	QuestToGiveAfter = nil
}

return module
