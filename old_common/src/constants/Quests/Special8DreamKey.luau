local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

local Item = 'DreamKey'
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local DisplayName = require(ReplicatedStorage:WaitForChild('Registry'):WaitForChild('Items'):WaitForChild(Item)).configuration.DisplayName

module.configuration = {
	DisplayName = `[Solo] Get {DisplayName}`,
	Description = `Gain {DisplayName} in your item inventory!`,
	PointsNeeded = 1, --0 = free
	VisualType = "Points", --could also be "Percent"
	
	Order = -93,
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "SoloLevelling",
	QuestPointType = `GetItem{Item}`,
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
