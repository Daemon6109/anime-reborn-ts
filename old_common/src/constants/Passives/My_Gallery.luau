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
	PassiveName = "My Gallery",
	PassiveDescription = "Every 10 seconds unit summons a clone, which does 150% of his damage.",

	SummonName = "Krollo Clone",
	MaximumSummons = 15,
} 

Passive.callbacks = {

	onPlace = function(self, Unit: Model)
		task.spawn(function()
			local BuffLib = require(replicated.Libs.BuffLib)
			local AllMultiPath = replicated.GameVariables:GetAttribute("AllMultiPath")
			local CurrentlySpawned = 0

			local function SpawnClone(_PathNumber)
				local config = _G.AllyAPI:buildAllyConfig(Unit, Passive.configuration.SummonName, deepCopy(_G.Registry.registry.AllyNPC[Passive.configuration.SummonName]), replicated.GameVariables.CurrentWave.Value, nil, _PathNumber)
				local Health = 100
				if BuffLib:GetDamage(Unit) then
					Health = BuffLib:GetDamage(Unit) * 1.5
				end
				
				config.Health = Health
				
				_G.AllyAPI:SpawnAlly(config, replicated.GameVariables.CurrentWave.Value)
			end

			while task.wait(10/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value) do
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