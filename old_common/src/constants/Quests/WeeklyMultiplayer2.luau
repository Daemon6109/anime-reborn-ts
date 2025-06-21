local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Weekly Multiplayer II",
	Description = "Clear 500 Waves with a friend.",
	PointsNeeded = 500, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	QuestType = "Weekly", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Multiplayer", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 650,
		},

		Items = {
			["TraitCrystal"] = 2,
			["FrostKey"] = 2
		},

		Units = {},

		BattlepassExp = 300
	},
	
	QuestToGiveAfter = nil
}

return module
