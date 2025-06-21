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
	PassiveName = "Light mimicry",
	PassiveDescription = "When this unit eliminates an enemy, there's 35% chance to spawn a light servant with 80% of enemy health. (Caps health at x10 unit damage)",
	SummonName = "Light Servant",
	--MaximumSummons = 15,
} 

Passive.callbacks = {
	onKill = function(self: {any}, Unit: Model, Enemy: {any}?)
		local BuffLib = require(replicated.Libs.BuffLib)
		local AllMultiPath = replicated.GameVariables:GetAttribute("AllMultiPath")

		if math.random(1,100) <= 35 and tick()-(Unit:GetAttribute("SpawnCD") or 0) > 15 then
			Unit:SetAttribute("SpawnCD", tick())

			IsMultipath = workspace:FindFirstChild("MultiPath")
			PathRoot = IsMultipath and workspace:FindFirstChild("MultiPath") or workspace:FindFirstChild("Path")
			MultipathPaths = IsMultipath and IsMultipath:GetChildren()
			
			local function SpawnClone(_PathNumber)
				local Template = _G.AllyAPI:buildAllyConfig(Unit, Passive.configuration.SummonName, deepCopy(_G.Registry.registry.AllyNPC[Passive.configuration.SummonName]), replicated.GameVariables.CurrentWave.Value, nil, _PathNumber)

				Template.Health = (Enemy.MaxHealth or 1000) * .8

				if Template.Health > BuffLib:GetDamage(Unit) * 10 then
					Template.Health = BuffLib:GetDamage(Unit) * 10
				end

				_G.AllyAPI:SpawnAlly(Template)
			end

			for _PathNumber = 1, AllMultiPath and CountMultiPathPaths() or 1 do
				SpawnClone(AllMultiPath and _PathNumber or nil)
			end
		end

		BuffLib = nil
	end,
}

return Passive