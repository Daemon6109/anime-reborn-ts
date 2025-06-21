local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
	end,
	
	BuildDescription = function(ExtraData)
		return `Complete the stage!`
	end,
}
