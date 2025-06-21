local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Hallow] Feed Hallow King",
	Description = "Feed Hallow King 30 reaper parts.",
	PointsNeeded = 1, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	Order = -105;
	
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
