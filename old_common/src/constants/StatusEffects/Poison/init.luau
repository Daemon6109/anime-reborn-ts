local module = {}

local Replicated = game:GetService("ReplicatedStorage")
local HTTP = game:GetService("HttpService")
local Events = Replicated.Events
local BuffLib

local debris = require(Replicated.Libs.DebrisSystemV2)
local AnimModule = require(Replicated.AnimModule)

module.EnemiesCDs = {}
module.EffectCooldown = 0
module.Stackable = false
module.Root = script

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.StatusEffectsBaseMethods)})

function module:OnServer(Unit, Enemies, Duration)
	if not BuffLib then
		BuffLib = require(Replicated.Libs.BuffLib)
	end
	
	local Constructs = module:RemoveEnemiesOnCD(module:GetEnemyConstructs(Enemies))
	
	--local Damage = (Unit.configuration.Damage.Value * Unit:GetAttribute(`BuffedDamage`)) * .05
	local Damage = (BuffLib:GetDamage(Unit) * .03)*BuffLib:GetStatusEffectDamageMulti(Unit)
	local DMGDelay = 1

	module:SendInfoToClientDOT(Unit, Constructs, Duration, {
		Damage = Damage,
		DMGDelay = DMGDelay,
		Duration = Duration
	})
	
	module:AddEnemiesCD(Constructs,Duration)
	
	local AttackUID = HTTP:GenerateGUID(false)
	
	task.defer(function()
		local start = tick()
		while tick()-start < Duration do
			for i, EnemyConstruct in ipairs(Constructs) do
				if EnemyConstruct then
					if EnemyConstruct and EnemyConstruct.Health > 0 then
						_G.EnemyAPI:DamageEnemy(EnemyConstruct.EnemyID, Damage, AttackUID, Unit)
						--EnemyConstruct:UpdateEnemy("Health",EnemyConstruct.Health - 100)
					end
				end
			end
			--Events.VisualEffects:FireAllClients("DotDamage", nil, nil, nil, module:GetEnemyIDs(Enemies), Damage)
			task.wait(DMGDelay)
		end
	end)
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

--function module:VFXandAnim(EnemyModel, Duration)
--	local particles = {}
	
--	for i,v in pairs(script.Particles:GetChildren()) do
--		local particle = v:Clone()
--		particle.Parent = EnemyModel:FindFirstChild(v:GetAttribute("Part"))
--		particle.Enabled = true
--		table.insert(particles,particle)
--	end
	
--	task.wait(Duration)
	
--	for i,v in particles do
--		v:Destroy()
--	end
--end

return module