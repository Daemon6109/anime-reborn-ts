local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "Weekly Eliminations I",
	Description = "Get 50000 eliminations from any gamemode.",
	PointsNeeded = 50000, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	QuestType = "Weekly", --"Daily", "Weekly", "Infinite", "Story"
	QuestPointType = "Eliminations", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 500,
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
