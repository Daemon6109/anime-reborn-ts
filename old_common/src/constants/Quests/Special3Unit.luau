local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.QuestBaseMethods)})

local Unit = 'Beru [Evo2]'
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local DisplayName = require(ReplicatedStorage:WaitForChild('Registry'):WaitForChild('Units'):WaitForChild(Unit)).configuration.DisplayName

module.configuration = {
	DisplayName = `[Solo] Get {DisplayName}`,
	Description = `Gain {DisplayName} in your collection!`,
	PointsNeeded = 1, --0 = free
	VisualType = "Points", --could also be "Percent"
	RequiredUnit = Unit,
	
	Order = -98,
	QuestType = "Special", --"Daily", "Weekly", "Infinite", "Story"
	SpecialType = "SoloLevelling",
	QuestPointType = `GetUnit{Unit}`,
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
