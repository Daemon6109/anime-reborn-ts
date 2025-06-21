local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

module.configuration = {
	DisplayName = "[Solo] Secret Potals",
	Description = "Beat the secret ruined ant cave portal 5 times",
	PointsNeeded = 5, --0 = free
	VisualType = "Percent", --could also be "Percent"
	
	Order = -94,
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "SoloLevelling",
	QuestPointType = "SecretRuinedPortal", --used for bulk point giving
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
