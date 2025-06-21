local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

local IsMultipath = workspace:FindFirstChild("MultiPath")
local PathRoot = IsMultipath and workspace:FindFirstChild("MultiPath") or workspace:FindFirstChild("Path")
local MultipathPaths = IsMultipath and IsMultipath:GetChildren()

local function CountMultiPathPaths()
	local x = 0
	if MultipathPaths then
		for i, v in MultipathPaths do
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
	PassiveName = "Arise",
	PassiveDescription = "For every 10 kills he gets, he summons a shadow of the fallen enemy with the hp of 40% of the damage, If it's a boss it'll resummon with 30% of its previous hp.",
	SummonName = "Shadow Knight",
	SummonDelay = 0.5,
	KillsToSummon = 10,
	MaximumSummons = 10
}

local function GetSummonCap()
	return IsMultipath and Passive.configuration.MaximumSummons * CountMultiPathPaths() or Passive.configuration.MaximumSummons
end

local AllMultiPath = replicated.GameVariables:GetAttribute("AllMultiPath")
local CurrentlySpawned = 0

local summonQueue = {}
local isProcessingQueue = false

local function SpawnClone(Unit, _PathNumber, HP)
	if CurrentlySpawned < GetSummonCap() then
		CurrentlySpawned += 1
		_G.AllyAPI:SpawnAlly(
			_G.AllyAPI:buildAllyConfig(
				Unit, 
				Passive.configuration.SummonName, 
				deepCopy(_G.Registry.registry.AllyNPC[Passive.configuration.SummonName]), 
				replicated.GameVariables.CurrentWave.Value, 
				nil, 
				_PathNumber, 
				HP
			), 
			function()
				CurrentlySpawned -= 1
			end
		)
	end
end

local function processSummonQueue()
	if isProcessingQueue then return end
	isProcessingQueue = true
	while #summonQueue > 0 do
		local summonData = table.remove(summonQueue, 1)
		SpawnClone(summonData.Unit, summonData.PathNumber, summonData.HP)
		task.wait(Passive.configuration.SummonDelay / game:GetService('ReplicatedStorage').GameVariables.GameSpeed.Value)
	end
	isProcessingQueue = false
end

local killCounter = 0

Passive.callbacks = {
	onKill = function(self, Unit: Model, Enemy: {any})
		task.spawn(function()
			killCounter = killCounter + 1

			if killCounter % Passive.configuration.KillsToSummon == 0 then
				IsMultipath = workspace:FindFirstChild("MultiPath")
				PathRoot = IsMultipath and workspace:FindFirstChild("MultiPath") or workspace:FindFirstChild("Path")
				MultipathPaths = IsMultipath and IsMultipath:GetChildren()

				local BuffLib = require(replicated.Libs.BuffLib)
				local Damage = BuffLib:GetDamage(Unit)
				local HP = Damage * 0.4
				if Enemy.IsBoss then
					HP = Enemy.MaxHealth * 0.3
				end

				local BlackHeartStacks = Unit:GetAttribute("BlackHeartStacks")

				if BlackHeartStacks then
					HP = HP * (1 + 0.013 * BlackHeartStacks)
				end

				local chosenPathNumber = nil
				if AllMultiPath then
					local pathsCount = CountMultiPathPaths()
					if pathsCount > 0 then
						chosenPathNumber = math.random(1, pathsCount)
					end
				end

				table.insert(summonQueue, {Unit = Unit, PathNumber = chosenPathNumber, HP = HP})
				processSummonQueue()
			end
		end)
	end,
}

return Passive
