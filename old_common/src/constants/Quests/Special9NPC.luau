local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Solo] Speak to Solo Woo",
	Description = "Speak to Solo Woo in the lobby and claim your reward.",
	PointsNeeded = 1, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	Order = -92,
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "SoloLevelling",
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
