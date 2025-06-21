local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Ascended] The Prince",
	Description = "Get Vegoto and Evolve Him",
	PointsNeeded = 1, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	Order = -205;
	
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "Reborn",
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
