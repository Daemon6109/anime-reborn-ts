local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Weekly Infinite",
	Description = "Clear 150 waves in any map in Infinite Mode.",
	PointsNeeded = 150, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	QuestType = "Weekly", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Infinite", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 550,
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
