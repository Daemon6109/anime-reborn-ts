local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = false
		
		local con1
		local con2
		
		if not GameVariables.GameStarted.Value then
			GameVariables.GameStarted.Changed:Wait()
		end

		con1 = GameVariables.CurrentWave.Changed:Connect(function()
			if GameVariables.CurrentWave.Value == ExtraData.Wave then
				GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
				con1:Disconnect()
				con2:Disconnect()
			end
		end)
		
		con2 = GameVariables.GameFinished.Changed:Connect(function()
			con1:Disconnect()
			con2:Disconnect()
		end)
	end,
	
	BuildDescription = function(ExtraData)
		return `Complete wave {ExtraData.Wave}!`
	end,
}
