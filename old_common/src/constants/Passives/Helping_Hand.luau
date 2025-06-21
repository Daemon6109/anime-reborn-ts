local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Helping Hand",
	PassiveDescription = "Boosts the DMG of a `Fire` element ally with the least amount of eliminations in the range by +35%",
	PercentIncrease = .35,
	TagName = "HelpingHand",
} 

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		Unit:AddTag(`{Passive.configuration.TagName}Host`)
		Unit:SetAttribute(`{Passive.configuration.TagName}HostId`, Unit:GetAttribute("IUUID"))
		
		task.spawn(function()
			local CurrentlyBuffed;
			local IUUID = Unit:GetAttribute("IUUID")

			while task.wait(1 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value) do
				if not Unit or not Unit.Parent then
					break
				end
				
				if CurrentlyBuffed ~= nil and CurrentlyBuffed.Parent == nil then
					CurrentlyBuffed = nil
				end

				local Allies = _G.UnitHandler:GetAllyUnitsInRange(Unit)
				local SortedTable = {}
				local CurrentElims = CurrentlyBuffed ~= nil and CurrentlyBuffed:GetAttribute("Eliminations") or math.huge

				for _, Ally in Allies do
					local config = Ally:FindFirstChild("configuration")
					if config then
						if config.Element.Value == "Fire" and not Ally:HasTag(Passive.configuration.TagName) then
							local AllyElims = Ally:GetAttribute("Eliminations")
							if not CurrentlyBuffed or CurrentElims > AllyElims then
								table.insert(SortedTable, {ally = Ally, count = AllyElims})
							end
						end
					end
				end

				table.sort(SortedTable, function(a, b)
					return a.count < b.count
				end)

				if #SortedTable > 0 then
					if CurrentlyBuffed ~= nil then
						CurrentlyBuffed:RemoveTag(Passive.configuration.TagName)
						CurrentlyBuffed:SetAttribute("PermanentDamageMulti", CurrentlyBuffed:GetAttribute("PermanentDamageMulti")-Passive.configuration.PercentIncrease)
						CurrentlyBuffed:SetAttribute(`{Passive.configuration.TagName}Id`, nil)
					end
					CurrentlyBuffed = SortedTable[1].ally
					CurrentlyBuffed:AddTag(Passive.configuration.TagName)
					CurrentlyBuffed:SetAttribute("PermanentDamageMulti", CurrentlyBuffed:GetAttribute("PermanentDamageMulti")+Passive.configuration.PercentIncrease)
					CurrentlyBuffed:SetAttribute(`{Passive.configuration.TagName}Id`, IUUID)
				end
			end
		end)
	end,
	onRemove = function(self, Unit: Model)
		local IUUID = Unit:GetAttribute("IUUID")
		
		for _, Ally in workspace.UnitsPlaced:GetChildren() do
			if Unit == Ally then
				continue
			end
			
			print(Ally:HasTag(Passive.configuration.TagName), Ally:GetAttribute(`{Passive.configuration.TagName}Id`), Ally:GetAttribute(`{Passive.configuration.TagName}Id`) == IUUID)
			
			if Ally:HasTag(Passive.configuration.TagName) and Ally:GetAttribute(`{Passive.configuration.TagName}Id`) == IUUID then
				print("clearing")
				Ally:SetAttribute("PermanentDamageMulti", Ally:GetAttribute("PermanentDamageMulti")-Passive.configuration.PercentIncrease)
				Ally:RemoveTag(Passive.configuration.TagName)
				Ally:SetAttribute(`{Passive.configuration.TagName}Id`, nil)
			end
		end
	end,
}

return Passive
