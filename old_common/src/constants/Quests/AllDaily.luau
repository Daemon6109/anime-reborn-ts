local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Daily Quests",
	Description = "Complete all Daily Quests.",
	PointsNeeded = 3, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Daily", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "", --used for bulk point giving
	Available = false,
	Image = "131342657009076",
	
	Order = -1,
	
	Reward = {
		Currencies = {
			Gems = 750,
			Gold = 1200,
		},

		Items = {
			["TraitCrystal"] = 2,
			["FrostKey"] = 3
		},

		Units = {},
		
		BattlepassExp = 750
	},
	
	QuestToGiveAfter = nil
}

return module
