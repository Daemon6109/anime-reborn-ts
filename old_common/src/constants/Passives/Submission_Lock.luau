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
	PassiveName = "Submission Lock",
	PassiveDescription = "On every 15th attack robin summons a tornado, `Stuns` everyone hit for 2.5 seconds Immobilized enemies take 15% more damage while having that status effect",

	SummonName = "Tornado",
	MaximumSummons = 15,
} 

Passive.callbacks = {

	onAttack = function(self, Unit: Model)

		Unit:SetAttribute("PassiveStun", false)
		local PassiveStacks = Unit:GetAttribute("PassiveStacks") or 0
		Unit:SetAttribute("PassiveStacks", PassiveStacks + 1)
		if PassiveStacks >= 1 then
			Unit:SetAttribute("PassiveStacks", 0)
			Unit:SetAttribute("PassiveStun", true)
			Unit:SetAttribute("CanSummonTornado", true)
		end

	end,

	onPlace = function(self, Unit: Model)
		task.spawn(function()
			local AllMultiPath = replicated.GameVariables:GetAttribute("AllMultiPath")
			local CurrentlySpawned = 0

			local function SpawnClone(_PathNumber)
				local config = _G.AllyAPI:buildAllyConfig(Unit, Passive.configuration.SummonName, deepCopy(_G.Registry.registry.AllyNPC[Passive.configuration.SummonName]), replicated.GameVariables.CurrentWave.Value, nil, _PathNumber)
				_G.AllyAPI:SpawnAlly(config, replicated.GameVariables.CurrentWave.Value)
			end

			while task.wait(1/ game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value) do

				local CanSummonTornado = Unit:GetAttribute("CanSummonTornado") or false

				if CanSummonTornado then
					
					Unit:SetAttribute("CanSummonTornado", false)
					
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
			end
		end)
	end,

}

return Passive