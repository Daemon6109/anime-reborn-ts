local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = false
		
		local con1
		local con2
		
		local Amount = 0
		
		con1 = workspace.UnitsPlaced.ChildAdded:Connect(function(Child)
			if Child.configuration.Element.Value == ExtraData.Element then
				Amount += 1
			end
			
			if Amount >= ExtraData.Amount then
				GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
				con1:Disconnect()
				con2:Disconnect()
			end
		end)
		
		con2 = GameVariables.GameFinished.Changed:Connect(function(newVal)
			if newVal == true then
				con1:Disconnect()
				con2:Disconnect()
			end
		end)
	end,
	
	BuildDescription = function(ExtraData)
		return `Place at least {ExtraData.Amount} units that have {string.lower(ExtraData.Element)} element.`
	end,
}
