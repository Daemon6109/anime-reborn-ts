local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.ModifierCardBaseMethods)})

module.configuration = {
	Type = "Buff",
	Description = "Your units get stronger!",
	Title = "Attack II",
	TopStat = "+20% more damage",
	Icon = "rbxassetid://104061795955315",
	
	EventTokenMultiplier = 1,
	
	GameVariablesSet = {
		
	},
	
	GameVariablesAdd = {
		
	},
	
	AllUnitsSet = {
		
	},
	
	AllUnitsAdd = {
		PermanentDamageMulti = .08
	}
	
}

return module
