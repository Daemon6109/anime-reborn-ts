local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Hallow] Talk to me",
	Description = "Complete all the Hallow Quests!",
	PointsNeeded = 1, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	Order = -102;
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "HallowKing",
	Available = true,
	Image = "131342657009076",

	Reward = {
		Currencies = {
		},

		Items = {
			--['Lanzar'] = 1
		},

		Units = {},
	},
}

return module
