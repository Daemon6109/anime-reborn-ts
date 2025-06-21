local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Weekly Multiplayer I",
	Description = "Clear 300 Waves with a friend.",
	PointsNeeded = 300, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	QuestType = "Weekly", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Multiplayer", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 350,
		},

		Items = {
			["TraitCrystal"] = 1	
		},

		Units = {},

		BattlepassExp = 300
	},
	
	QuestToGiveAfter = nil
}

return module
