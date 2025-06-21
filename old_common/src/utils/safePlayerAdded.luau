local Players = game:GetService("Players")

--[=[
	Calls the given callback for all existing players in the game, and any that join thereafter.

	Useful in situations where you want to run code for every player, even players who are already in the game.

	@param onPlayerAddedCallback (Player) -> () -- The callback function to be called for each player.
	@return RBXScriptConnection -- The connection object for the PlayerAdded event.
]=]
local function safePlayerAdded(onPlayerAddedCallback: (player: Player) -> ()): RBXScriptConnection
	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAddedCallback, player)
	end
	return Players.PlayerAdded:Connect(onPlayerAddedCallback)
end

return safePlayerAdded
