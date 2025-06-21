local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Multiplayer III",
	Description = "Play at least 50 waves with another player.",
	PointsNeeded = 50, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	QuestType = "Daily", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Multiplayer", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 300,
		},

		Items = {
			["TraitCrystal"] = 1,
			["FrostKey"] = 1
		},

		Units = {},

		BattlepassExp = 150
	},
	
	QuestToGiveAfter = nil
}

return module
