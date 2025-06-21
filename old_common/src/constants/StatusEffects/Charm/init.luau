local module = {}

local Replicated = game:GetService("ReplicatedStorage")
local Events = Replicated.Events

local debris = require(Replicated.Libs.DebrisSystemV2)
local AnimModule = require(Replicated.AnimModule)

module.EnemiesCDs = {}
module.EffectCooldown = 5
module.Stackable = false
module.Root = script

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.StatusEffectsBaseMethods)})

function module:OnServer(Unit, Enemies, Duration)
	local Constructs = module:RemoveEnemiesOnCD(module:GetEnemyConstructs(Enemies))
	module:AddEnemiesCD(Constructs,Duration)
	module:SendInfoToClient(Unit, Constructs, Duration)
	
	for i, EnemyConstruct in ipairs(Constructs) do
		if EnemyConstruct then
			if EnemyConstruct and EnemyConstruct.Health > 0 then
				EnemyConstruct:UpdateEnemy("IncomingDamageMulti", EnemyConstruct.IncomingDamageMulti+.15)
			end
		end
	end

	task.delay(Duration, function()
		for i, EnemyConstruct in ipairs(Constructs) do
			if EnemyConstruct then
				if EnemyConstruct and EnemyConstruct.Health > 0 then
					EnemyConstruct:UpdateEnemy("IncomingDamageMulti", EnemyConstruct.IncomingDamageMulti-.15)
				end
			end
		end
	end)
	
	for i, EnemyConstruct in ipairs(Constructs) do
		if EnemyConstruct then
			if EnemyConstruct and EnemyConstruct.Health > 0 then
				local Slowdown = -EnemyConstruct.OriginalSpeed*.25
				local ActiveSlowdown = nil

				if _G.EnemySpeedManager["Enemies"][EnemyConstruct] and _G.EnemySpeedManager["Enemies"][EnemyConstruct]["MainSlowdown"] then
					ActiveSlowdown = _G.EnemySpeedManager["Enemies"][EnemyConstruct]["MainSlowdown"]
				end

				if ActiveSlowdown and math.abs(ActiveSlowdown) > math.abs(Slowdown) then
					continue
				end

				_G.EnemySpeedManager["AddDirectBooster"]("MainSlowdown", EnemyConstruct, Slowdown, Duration)
			end
		end
	end
	
	--task.wait(Duration)

	--for i, EnemyConstruct in ipairs(Constructs) do
	--	if EnemyConstruct then
	--		if EnemyConstruct and EnemyConstruct.Health > 0 then
	--			EnemyConstruct:UpdateEnemy("Speed", EnemyConstruct.OriginalSpeed)
	--		end
	--	end
	--end
	
end

--function module:OnClient(Unit, Enemies, Duration)
--	for i, NpcData in ipairs(Enemies) do
--		if NpcData then
--			local NPCModel = workspace.NPC_Client_Models:FindFirstChild(NpcData.npc.EnemyID)
			
--			if not NPCModel then return end
			
--			local Status = self.BillboardGui:Clone()
--			Status.Parent = NPCModel:FindFirstChild("HumanoidRootPart")
--			debris.AddItem(Status,Duration)
--		end
--	end
--end

return module