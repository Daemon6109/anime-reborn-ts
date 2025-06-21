local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
		
		local con1
		local con2
		
		con1 = game["Run Service"].Heartbeat:Connect(function()
			if GameVariables.BaseHP.Value/GameVariables.BaseMaxHP.Value < ExtraData.HP then
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
		return `Have more than {ExtraData.HP*100}% base life.`
	end,
}
