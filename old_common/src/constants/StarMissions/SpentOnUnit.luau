local GameVariables = game.ReplicatedStorage.GameVariables

return {
	CheckCondition = function(Player, ExtraData)
		GameVariables.Stars[Player.Name][ExtraData.Star].Value = false

		local con1
		local con2
		local ConTab = {}
		
		con1 = workspace.UnitsPlaced.ChildAdded:Connect(function(Child)
			local Con; Con = Child.configuration.TotalPrice.Changed:Connect(function(NewVal)
				if Player.Name == Child.configuration.Owner.Value and NewVal >= ExtraData.Amount then
					GameVariables.Stars[Player.Name][ExtraData.Star].Value = true
					
					con1:Disconnect()
					con2:Disconnect()

					for i,v in pairs(ConTab) do
						v:Disconnect()
					end
				end	
			end)
			
			table.insert(ConTab,Con)
		end)

		con2 = GameVariables.GameFinished.Changed:Connect(function()
			con1:Disconnect()
			con2:Disconnect()
			
			for i,v in pairs(ConTab) do
				v:Disconnect()
			end
		end)
	end,

	BuildDescription = function(ExtraData)
		return `Spent at least {ExtraData.Amount}¥ on a unit or more.`
	end,
}
