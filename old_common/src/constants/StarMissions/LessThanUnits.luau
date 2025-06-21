local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
		
		local con1
		local con2
		
		--local Amount = 0
		
		con1 = workspace.UnitsPlaced.ChildAdded:Connect(function(Child)
			--Amount += 1
			local Amount = #workspace.UnitsPlaced:GetChildren()
			if Amount > ExtraData.Amount then
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
		return `Place less than {ExtraData.Amount} units.`
	end,
}
