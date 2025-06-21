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
			
			warn("is an ally")

			if not v:GetAttribute("Locked") then
				warn("not locked")
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
	PassiveName = "Crystal Lord",
	PassiveDescription = "Summons Crystal Servants each 10 seconds, up to 15 Servants at the same time. On multipath maps the cap is: Limit x Path Count.",
	SummonName = "Crystal Servant",
	MaximumSummons = 15,
} 


local function GetSummonCap()
	return IsMultipath and Passive.configuration.MaximumSummons*CountMultiPathPaths() or Passive.configuration.MaximumSummons
end

Passive.callbacks = {
	onPlace = function(self, Unit: Model)
		task.spawn(function()
			local AllMultiPath = replicated.GameVariables:GetAttribute("AllMultiPath")
			--repeat task.wait() until _G.AllyAPI
			local CurrentlySpawned = 0


			local function SpawnClone(_PathNumber)
				if CurrentlySpawned == GetSummonCap() then
					repeat task.wait(1) until CurrentlySpawned < GetSummonCap()
				end

				CurrentlySpawned += 1
				_G.AllyAPI:SpawnAlly(_G.AllyAPI:buildAllyConfig(Unit, Passive.configuration.SummonName, deepCopy(_G.Registry.registry.AllyNPC[Passive.configuration.SummonName]), replicated.GameVariables.CurrentWave.Value, nil, _PathNumber), function()
					CurrentlySpawned -= 1
				end)
			end

			if AllMultiPath then
				for _PathNumber = 1, CountMultiPathPaths() do
					SpawnClone(_PathNumber)
				end
			else
				SpawnClone()
			end

			while task.wait(10 / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value) do
				if not Unit and not Unit.Parent then
					break
				end
				
				IsMultipath = workspace:FindFirstChild("MultiPath")
				PathRoot = IsMultipath and workspace:FindFirstChild("MultiPath") or workspace:FindFirstChild("Path")
				MultipathPaths = IsMultipath and IsMultipath:GetChildren()
				
				if AllMultiPath then
					for _PathNumber = 1, CountMultiPathPaths() do
						SpawnClone(_PathNumber)
					end
				else
					SpawnClone()
				end
			end
		end)
	end,
}

return Passive