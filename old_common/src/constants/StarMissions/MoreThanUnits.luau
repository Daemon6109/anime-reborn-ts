local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = false
		
		local con1
		local con2
		
		local Amount = 0
		
		con1 = workspace.UnitsPlaced.ChildAdded:Connect(function(Child)
			Amount += 1
			if Amount > ExtraData.Amount then
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
		return `Place more than {ExtraData.Amount} units.`
	end,
}
