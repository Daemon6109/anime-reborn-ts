local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
		
		local con1
		local con2
		
		if not GameVariables.GameStarted.Value then
			GameVariables.GameStarted.Changed:Wait()
		end
		
		local Final = false
		local Start = 0
		
		con1 = game["Run Service"].Heartbeat:Connect(function()
			if not Final then
				if GameVariables.CurrentWave.Value == GameVariables.MaxWaves.Value and GameVariables.MaxWaves.Value ~= 0 then
					Start = tick()
					Final = true
					GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
				end
			else
				if tick()-Start > ExtraData.Time and GameVariables.GameFinished.Value == false then
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
		return `Finish the final wave in less than {ExtraData.Time} seconds!`
	end,
}
