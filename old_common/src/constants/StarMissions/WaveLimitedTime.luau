local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
		
		local con1
		local con2
		
		if not GameVariables.GameStarted.Value then
			GameVariables.GameStarted.Changed:Wait()
		end
		
		local Start = 0
		local Started = false
		
		con1 = game["Run Service"].Heartbeat:Connect(function()
			if GameVariables.CurrentWave.Value == ExtraData.Wave then
				if not Started then
					Start = tick()
					Started = true
					GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
				end
				
				if tick()-Start > ExtraData.Time then
					GameVariables.Stars[Player.Name][ExtraData.Star].Value = false
					con1:Disconnect()
					con2:Disconnect()
				end
			end
		end)
		
		con2 = GameVariables.GameFinished.Changed:Connect(function()
			con1:Disconnect()
			con2:Disconnect()
		end)
	end,
	
	BuildDescription = function(ExtraData)
		return `Complete wave {ExtraData.Wave} in less than {ExtraData.Time} seconds.`
	end,
}
