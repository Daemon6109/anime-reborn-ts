local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Solo] Portals",
	Description = "Complete 25 Tier 6 Ruined Ant Cave Portals.",
	PointsNeeded = 25, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	Order = -95,
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "SoloLevelling",
	QuestPointType = "T6RuinedPortal", --used for bulk point giving
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
