local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = false

		local con1
		local con2
		local con3

		local conTable = {}
		local UnitsLevel = {}

		local points = 0

		con1 = workspace.UnitsPlaced.ChildAdded:Connect(function(Child)
			local Con; Con = Child.configuration.CurrentUpgrade.Changed:Connect(function(NewVal)
				UnitsLevel[Child] = {NewVal, Child.configuration.Owner.Value}
			end)
			
			table.insert(conTable, Con)
		end)
		
		con2 = workspace.UnitsPlaced.ChildRemoved:Connect(function(Child)
			if UnitsLevel[Child] then
				if UnitsLevel[Child][1] >= ExtraData.Upgrade and Player.Name == UnitsLevel[Child][2] then
					points += 1

					if points >= ExtraData.Amount then
						GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
						con1:Disconnect()
						con2:Disconnect()
						con3:Disconnect()
						
						for i,v in pairs(conTable) do
							v:Disconnect()
						end
					end
				end
			end
		end)

		con3 = GameVariables.GameFinished.Changed:Connect(function()
			con1:Disconnect()
			con2:Disconnect()
			con3:Disconnect()
			
			for i,v in pairs(conTable) do
				v:Disconnect()
			end
		end)
	end,

	BuildDescription = function(ExtraData)
		return `Sell at least {ExtraData.Amount} {ExtraData.Amount > 1 and "units" or "unit"} at Upgrade {ExtraData.Upgrade} or above.`
	end,
}
