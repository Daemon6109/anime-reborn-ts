local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
		
		local con1
		local con2
		
		if not GameVariables.GameStarted.Value then
			GameVariables.GameStarted.Changed:Wait()
		end
		
		local Start = tick()
		
		con1 = game["Run Service"].Heartbeat:Connect(function()
			--print(tick()-Start)
			--print(ExtraData.Time*60)
			--print(tick()-Start > ExtraData.Time*60)
			if tick()-Start > ExtraData.Time*60 then
				GameVariables.Stars[Player.Name][ExtraData.Star].Value = false
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
		return `Finish act in less than {ExtraData.Time} minutes!`
	end,
}
