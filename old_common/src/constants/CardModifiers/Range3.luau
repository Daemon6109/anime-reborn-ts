local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.ModifierCardBaseMethods)})

module.configuration = {
	Type = "Buff",
	Description = "Your units get more range!",
	Title = "Range III",
	TopStat = "+25% more range",
	Icon = "rbxassetid://101813926117765",
	
	EventTokenMultiplier = 1,
	
	GameVariablesSet = {
		
	},
	
	GameVariablesAdd = {
		
	},
	
	AllUnitsSet = {
		
	},
	
	AllUnitsAdd = {
		PermanentRangeMulti = .05
	}
	
}

return module
