local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.ModifierCardBaseMethods)})

module.configuration = {
	Type = "Buff",
	Description = "Everyone gets some money!",
	Title = "Money I",
	TopStat = "+5000 Yen",
	Icon = "rbxassetid://130420558969490",
	
	EventTokenMultiplier = 1,
	
	GameVariablesSet = {
		
	},
	
	GameVariablesAdd = {
		
	},
	
	AllUnitsSet = {
		
	},
	
	AllUnitsAdd = {

	}
	
}

module.CustomFunction = function()
	for i,v in pairs(game.Players:GetChildren()) do
		v:WaitForChild("notSavable"):WaitForChild("money").Value += 5000
	end
end

return module
