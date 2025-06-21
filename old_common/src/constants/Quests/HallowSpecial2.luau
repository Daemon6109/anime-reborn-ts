local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Hallow] Kill Hallows",
	Description = "Kill 200 Hallow Enemies!",
	PointsNeeded = 200, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	Order = -104;
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "HallowKing",
	Available = true,
	Image = "131342657009076",

	Reward = {
		Currencies = {
		},

		Items = {
			--['Black Heart'] = 1
		},

		Units = {},
	},
}

return module
