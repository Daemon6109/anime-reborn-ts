local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Ascended] Surpassing the limits",
	Description = "Finish Elemental Caverns 10 Times",
	PointsNeeded = 10, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	Order = -200;
	
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "Reborn",
	Available = true,
	Image = "131342657009076",

	Reward = {
		Currencies = {
		},

		Items = {
		},

		Units = {},
	},
}

return module
