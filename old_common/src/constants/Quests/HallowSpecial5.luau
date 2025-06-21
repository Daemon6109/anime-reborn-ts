local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Hallow] Orihime",
	Description = "Talk to Orihime and see what she has to say!",
	PointsNeeded = 1, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	Order = -101;
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "HallowKing",
	Available = true,
	Image = "131342657009076",

	Reward = {
		Currencies = {
		},

		Items = {
			['OrihimeHeart'] = 1
		},

		Units = {},
	},
}

return module
