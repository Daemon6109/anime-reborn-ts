local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

local IsMultipath = workspace:FindFirstChild("MultiPath")
local PathRoot = IsMultipath and workspace:FindFirstChild("MultiPath") or workspace:FindFirstChild("Path")
local MultipathPaths = IsMultipath and IsMultipath:GetChildren()

local function CountMultiPathPaths()
	local x = 0

	if MultipathPaths then
		for i,v in MultipathPaths do
			if string.find(v.Name, "Ally") then
				continue
			end

			if not v:GetAttribute("Locked") then
				x += 1
			end		
		end
	end

	return x
end

local function deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

Passive.configuration = {
	PassiveName = "Doppelganger",
	PassiveDescription = "For every 20 enemies defeated, Smiling Valentine summons 3 clones, each with triple his HP. When a clone dies, it explodes, dealing damage equal to one-third of its maximum HP.",
	TagName = "Doppelganger",
	SummonName = "Doppelganger",
	MaximumSummons = 12,
	--ProcChance = 25,
}

local function GetSummonCap()
	return IsMultipath and Passive.configuration.MaximumSummons*CountMultiPathPaths() or Passive.configuration.MaximumSummons
end

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		local Maid = require(game.ReplicatedStorage.Maid).new()
		
		Maid:GiveTask("OnUnitDestroyed", Unit.Destroying, function()
			Maid:Dispose()
			Maid = nil
		end)
		
		Maid:GiveTask("OnEnemyKilled", workspace.NPC.ChildRemoved, function(EnemyFolder)
			Unit:SetAttribute(`{Passive.configuration.TagName}Stacks`, (Unit:GetAttribute(`{Passive.configuration.TagName}Stacks`) or 0)+1)
		end)
	end,
	onAttack = function(self, Unit: Model)
		local CurrentStacks = Unit:GetAttribute(`{Passive.configuration.TagName}Stacks`) or 0
		local Charges = math.clamp(math.floor(CurrentStacks/20), 0, 4)
		
		if Charges > 0 and not Unit:HasTag(Passive.configuration.TagName) then
			IsMultipath = workspace:FindFirstChild("MultiPath")
			PathRoot = IsMultipath and workspace:FindFirstChild("MultiPath") or workspace:FindFirstChild("Path")
			MultipathPaths = IsMultipath and IsMultipath:GetChildren()
			
			local AllMultiPath = replicated.GameVariables:GetAttribute("AllMultiPath")
			Unit:SetAttribute(`{Passive.configuration.TagName}Stacks`, Unit:GetAttribute(`{Passive.configuration.TagName}Stacks`)-(Charges*20))
			
			local function SpawnClone(_PathNumber)
				local CurrentlySpawned = Unit:GetAttribute(`{Passive.configuration.SummonName}Spawned`) or 0
				
				if CurrentlySpawned == GetSummonCap() then
					repeat
						CurrentlySpawned = Unit:GetAttribute(`{Passive.configuration.SummonName}Spawned`) or 0
						task.wait(1 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value) 
					until CurrentlySpawned < GetSummonCap()
				end

				Unit:SetAttribute(`{Passive.configuration.SummonName}Spawned`, CurrentlySpawned+1)
				
				CurrentlySpawned = nil
				
				local Template = _G.AllyAPI:buildAllyConfig(Unit, Passive.configuration.SummonName, deepCopy(_G.Registry.registry.AllyNPC[Passive.configuration.SummonName]), replicated.GameVariables.CurrentWave.Value, nil, _PathNumber)
				
				Template.Health *= 3
				
				_G.AllyAPI:SpawnAlly(Template, function()
					Template = nil
					local CurrentlySpawned = Unit:GetAttribute(`{Passive.configuration.SummonName}Spawned`) or 0
					Unit:SetAttribute(`{Passive.configuration.SummonName}Spawned`, CurrentlySpawned-1)
					CurrentlySpawned = nil
				end)
			end
			
			for i = 1, Charges*3 do
				if AllMultiPath then
					for _PathNumber = 1, CountMultiPathPaths() do
						SpawnClone(_PathNumber)
					end
				else
					SpawnClone()
				end
				task.wait(1 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)
			end
		end
	end,
}

return Passive
