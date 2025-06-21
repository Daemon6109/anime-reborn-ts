local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.ModifierCardBaseMethods)})

module.configuration = {
	Type = "Debuff",
	Description = "Enemies will have more health!",
	Title = "Enemy Health I",
	TopStat = "+50% enemy health",
	DownStat = "+10% event tokens",
	Icon = "rbxassetid://76900977676532",
	
	EventTokenMultiplier = 1.1,
	
	GameVariablesSet = {
		
	},
	
	GameVariablesAdd = {
		["EnemyGlobalHealthMultiplier"] = .5
	},
	
	AllUnitsSet = {
		
	},
	
	AllUnitsAdd = {
		
	}
	
}

return module
