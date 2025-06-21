local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = false
		
		local con1
		local con2
		
		con1 = Player:WaitForChild("notSavable").damage.Changed:Connect(function(NewNum)
			if NewNum >= ExtraData.Amount then
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
		return `Deal {ExtraData.Amount} Damage.`
	end,
}
