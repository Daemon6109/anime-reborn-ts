local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.ModifierCardBaseMethods)})

module.configuration = {
	Type = "Debuff",
	Description = "Enemies will go faster!",
	Title = "Enemy Speed I",
	TopStat = "+25% enemy speed",
	DownStat = "+10% event tokens",
	Icon = "rbxassetid://98707213171491",
	
	EventTokenMultiplier = 1.1,
	
	GameVariablesSet = {
		
	},
	
	GameVariablesAdd = {
		["EnemyGlobalSpeedMultiplier"] = .25
	},
	
	AllUnitsSet = {
		
	},
	
	AllUnitsAdd = {
		
	}
	
}

return module
