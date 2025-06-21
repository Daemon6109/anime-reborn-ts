local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.ModifierCardBaseMethods)})

module.configuration = {
	Type = "Buff",
	Description = "Your units get quicker!",
	Title = "Cooldown IV",
	TopStat = "-15% SPA",
	Icon = "rbxassetid://97379142531695",
	
	EventTokenMultiplier = 1,
	
	GameVariablesSet = {
		
	},
	
	GameVariablesAdd = {
		
	},
	
	AllUnitsSet = {
		
	},
	
	AllUnitsAdd = {
		PermanentAttackSpeedMulti = .05
	}
	
}

return module
