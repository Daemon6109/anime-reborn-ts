local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Solo] Speak to Solo Woo",
	Description = "Speak to Solo Woo in the lobby and see what he has to say.",
	PointsNeeded = 1, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	
	Order = -100,
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "SoloLevelling",
	QuestPointType = "NPC", --used for bulk point giving
	Available = true,
	Image = "131342657009076",
	
	Reward = {
		Currencies = {
			Gems = 50,
		},

		Items = {
		},

		Units = {},
	},
}

return module
