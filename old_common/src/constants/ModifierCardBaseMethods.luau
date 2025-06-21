local module = {}

local Replicated = game.ReplicatedStorage
local GameVariables = Replicated.GameVariables

function module:Execute()
	GameVariables.EventData.TokenMultiplier.Value += (self.configuration.EventTokenMultiplier-1)
	
	if self.configuration.GameVariablesSet then
		for i,v in pairs(self.configuration.GameVariablesSet) do
			if GameVariables.GlobalEnemyBuffs:FindFirstChild(i) then
				GameVariables.GlobalEnemyBuffs[i].Value = v
			end
		end
	end
	
	if self.configuration.GameVariablesAdd then
		for i,v in pairs(self.configuration.GameVariablesAdd) do
			if GameVariables.GlobalEnemyBuffs:FindFirstChild(i) then
				GameVariables.GlobalEnemyBuffs[i].Value += v
			end
		end
	end
	
	if self.configuration.AllUnitsSet then
		for i,v in pairs(self.configuration.AllUnitsSet) do
			for i,v in pairs(workspace.UnitsPlaced:GetChildren()) do
				if v:GetAttribute(i) then
					v:SetAttribute(i, v)
				end
			end
			
			GameVariables.GlobalUnitBuffs[i].Value = v
		end
	end
	
	if self.configuration.AllUnitsAdd then
		for i,v in pairs(self.configuration.AllUnitsAdd) do
			for i2,unitModel in pairs(workspace.UnitsPlaced:GetChildren()) do
				if unitModel:GetAttribute(i) then
					if i == "PermanentAttackSpeedMulti" then
						unitModel:SetAttribute(i, unitModel:GetAttribute(i) - v)
					else
						unitModel:SetAttribute(i, unitModel:GetAttribute(i) + v)
					end
				end
			end
			
			if i == "PermanentAttackSpeedMulti" then
				GameVariables.GlobalUnitBuffs[i].Value -= v
			else
				GameVariables.GlobalUnitBuffs[i].Value += v
			end
		end
	end
	
	if self.CustomFunction then
		self.CustomFunction()
	end
end

return module
