local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Weekly Quests",
	Description = "Finish all Weekly Quests.",
	PointsNeeded = 3, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Weekly", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "", --used for bulk point giving
	Available = false,
	Image = "131342657009076",
	
	Order = -1,
	
	Reward = {
		Currencies = {
			Gems = 2000,
			Gold = 7500
		},

		Items = {
			["TraitCrystal"] = 5,
			["FrostKey"] = 5
		},

		Units = {},
		
		BattlepassExp = 2500
	},
	
	QuestToGiveAfter = nil
}

return module
