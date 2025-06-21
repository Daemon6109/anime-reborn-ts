local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "TestPassive",
	PassiveDescription = "Yep",
	
	TrapSpawnTime = 1,
	TrapMaxAmount = 20,
	TrapRadius = 2
} 

Passive.callbacks = {
	onServerTick = function(self, Unit: Model, Delta: number)
		local BuffLib = require(replicated.Libs.BuffLib)
		local FastVector = require(replicated.Libs.FastVector).new()
		
		local UnitRange = BuffLib:GetRangeScaled(Unit)
		local UnitIUUID = Unit:GetAttribute("IUUID")
		
		--local Time = tick()
		
		if _G.ActiveMines and _G.ActiveMines[UnitIUUID] then
			for i,MinePart:Part in _G.ActiveMines[UnitIUUID] do
				for index, EnemyConstruct in pairs(_G.Constructs) do
					if EnemyConstruct then
						local Distance = FastVector:FastMagnitudeVec3(MinePart.Position, EnemyConstruct["Position"])
						
						if Distance < Passive.configuration.TrapRadius then
							--print("Damaged the enemy?")
							_G.EnemyAPI:DamageEnemy(EnemyConstruct.EnemyID, EnemyConstruct.Health, game.HttpService:GenerateGUID(false), Unit)
							MinePart:Destroy()
							_G.ActiveMines[UnitIUUID][i] = nil
							break
						end
					end
				end
			end
		end
		
		--print(`Collision Check: {tick()-Time}`)
		
		if tick()-(Unit:GetAttribute("SpawnCD") or 0) < Passive.configuration.TrapSpawnTime then return end
		
		--Time = tick()
		
		if not _G.PathForTraps then
			local PathTable = {}
			
			for i,v in pairs(workspace:WaitForChild("Path"):GetChildren()) do
				PathTable[tonumber(v.Name)] = v
			end
			
			_G.PathForTraps = {}
			
			for i,v:Model in ipairs(PathTable) do
				if v:FindFirstChild("Starter") then
					_G.PathForTraps[i] = {v.Starter, v.CornerEnd}
				elseif PathTable[i+1] then
					_G.PathForTraps[i] = {v.CornerEnd, PathTable[i+1].CornerStart}
				else
					_G.PathForTraps[i] = {v.CornerStart, v.End}
				end
			end
		end
		
		if not _G.ActiveMines then
			_G.ActiveMines = {}
		end
		
		if not _G.ActiveMines[UnitIUUID] then
			_G.ActiveMines[UnitIUUID] = {}
		end
		
		local Mines = 0		

		for i,v in _G.ActiveMines[UnitIUUID] do
			Mines += 1
		end
		
		if Mines >= Passive.configuration.TrapMaxAmount then return end

		local Placed = false
		local Tries = 0

		repeat
			if Tries > 100 then
				print("Overdid it")
				break
			end
			
			Tries += 1
			local Index = math.random(1, #_G.PathForTraps)
			local Pos = nil

			if _G.PathForTraps[Index] then
				Pos = _G.PathForTraps[Index][1].CFrame:Lerp(_G.PathForTraps[Index][2].CFrame, math.random(1,100)/100)

				local IsInRange = FastVector:FastMagnitudeVec3(Unit.HumanoidRootPart.Position, Pos.Position) <= UnitRange

				if IsInRange then
					local Part = script.Part:Clone()
					Part.CFrame = Pos
					Part.Orientation = Vector3.zero
					Part.Parent = workspace
					
					table.insert(_G.ActiveMines[UnitIUUID], Part)
					
					Placed = true
				end
			end
		until Placed
		
		--print(`Spawn Check: {tick()-Time}`)
		
		Unit:SetAttribute("SpawnCD", tick())
	end,
	
	onRemove = function(self, Unit: Model)
		local UnitIUUID = Unit:GetAttribute("IUUID")
		
		if _G.ActiveMines and _G.ActiveMines[UnitIUUID] then
			for i,v in _G.ActiveMines[UnitIUUID] do
				v:Destroy()
			end
			_G.ActiveMines[UnitIUUID] = nil
		end
		----print("hey")
		--for index, EnemyConstruct in pairs(_G.Constructs) do
		--	--print(EnemyConstruct.JuliusSlowdown)
		--	if EnemyConstruct.JuliusSlowdown then
		--		_G.EnemySpeedManager["Enemies"][EnemyConstruct][EnemyConstruct.JuliusSlowdown[1]] = nil

		--		EnemyConstruct.SlowdownImmunity = nil
		--		EnemyConstruct.JuliusSlowdown = nil
		--	end
		--end
	end,
}

return Passive
