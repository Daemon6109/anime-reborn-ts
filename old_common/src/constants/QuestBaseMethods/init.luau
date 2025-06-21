local module = {}

local Replicated = game.ReplicatedStorage
local RewardLib = require(game.ReplicatedStorage.Libs.RewardLibrary)

function module:Complete(Player)
	RewardLib:RewardPlayer(Player, self.configuration.Reward)
	
end

return module
