local module = {}

local Replicated = game:GetService("ReplicatedStorage")
local Events = Replicated.Events

local debris = require(Replicated.Libs.DebrisSystemV2)
local AnimModule = require(Replicated.AnimModule)

module.EnemiesCDs = {}
module.EffectCooldown = 10
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
				_G.EnemySpeedManager["AddBooster"](EnemyConstruct,-EnemyConstruct.OriginalSpeed,Duration)
				EnemyConstruct:UpdateEnemy("IncomingDamageMulti", EnemyConstruct.IncomingDamageMulti+.1)
			end
		end
	end
	
	task.delay(Duration, function()
		for i, EnemyConstruct in ipairs(Constructs) do
			if EnemyConstruct then
				if EnemyConstruct and EnemyConstruct.Health > 0 then
					EnemyConstruct:UpdateEnemy("IncomingDamageMulti", EnemyConstruct.IncomingDamageMulti-.1)
				end
			end
		end
	end)
	
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