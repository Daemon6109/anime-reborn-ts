local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.ModifierCardBaseMethods)})

module.configuration = {
	Type = "Debuff",
	Description = "Enemies have more shields!",
	Title = "Enemy Shields III",
	TopStat = "+8 more enemy shields",
	DownStat = "+10% event tokens",
	Icon = "rbxassetid://123024403397102",
	
	EventTokenMultiplier = 1.1,
	
	GameVariablesSet = {
		
	},
	
	GameVariablesAdd = {
		["EnemyGlobalShieldAddition"] = 3
	},
	
	AllUnitsSet = {
		
	},
	
	AllUnitsAdd = {
		
	}
	
}

return module
