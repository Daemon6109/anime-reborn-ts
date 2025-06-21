local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
		
		local con1
		local con2
		
		local TableMode = typeof(ExtraData.Type) == "table"
		
		con1 = workspace.UnitsPlaced.ChildAdded:Connect(function(Child)
			if TableMode then
				if not table.find(ExtraData.Type, Child.configuration.PlacementType.Value) then
					GameVariables.Stars[Player.Name][ExtraData.Star].Value = false
					con1:Disconnect()
					con2:Disconnect()
				end
			else
				if Child.configuration.PlacementType.Value ~= ExtraData.Type then
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
		local TableMode = typeof(ExtraData.Type) == "table"
		
		if TableMode then
			local DescriptionAddition = ""
			
			for i,v in pairs(ExtraData.Type) do
				if DescriptionAddition ~= "" then
					DescriptionAddition = DescriptionAddition..", "
				end
				DescriptionAddition = DescriptionAddition..`{string.lower(v)}`
			end
			
			return `Place only {DescriptionAddition} type of units.`
		else
			return `Place only {string.lower(ExtraData.Type)} type of units.`
		end
	end,
}
