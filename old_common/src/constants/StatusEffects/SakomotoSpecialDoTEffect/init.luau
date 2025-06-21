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
	local Damage = (BuffLib:GetDamage(Unit) * .05) * BuffLib:GetStatusEffectDamageMulti(Unit)
	local DMGDelay = 1

	module:SendInfoToClientDOT(Unit, Constructs, Duration, {
		Damage = Damage,
		DMGDelay = DMGDelay,
		Duration = Duration
	})
	
	module:AddEnemiesCD(Constructs,Duration)
	
	local AttackUID = HTTP:GenerateGUID(false)
	
	--for i,EnemyConstruct in Constructs do
	--	local currentEffects = EnemyConstruct.StatusEffects
	--	currentEffects[script.Name] = true
	--	EnemyConstruct:UpdateEnemy("StatusEffects", currentEffects)
	--end
	
	task.defer(function()
		local start = tick()
		while tick()-start < Duration do
			for i, EnemyConstruct in ipairs(Constructs) do
				if EnemyConstruct then
					if EnemyConstruct and EnemyConstruct.Health > 0 then
						_G.EnemyAPI:DamageEnemy(EnemyConstruct.EnemyID, Damage, AttackUID, Unit)
						if EnemyConstruct.Health <= 0 then
							Unit.configuration.AttackEffectDamageMultiplier.Value += .025
							local Stacks = Unit:GetAttribute("HitmanTricksStacks") or 0
							Unit:SetAttribute("HitmanTricksStacks", Stacks+1)
						end
						--EnemyConstruct:UpdateEnemy("Health",EnemyConstruct.Health - 100)
					end
				end
			end
			--Events.VisualEffects:FireAllClients("DotDamage", nil, nil, nil, module:GetEnemyIDs(Enemies), Damage)
			task.wait(DMGDelay)
		end

		--for i,EnemyConstruct in Constructs do
		--	if EnemyConstruct and EnemyConstruct.Health > 0 then
		--		local currentEffects = EnemyConstruct.StatusEffects
		--		currentEffects[script.Name] = false
		--		EnemyConstruct:UpdateEnemy("StatusEffects", currentEffects)
		--		--local ToRemove = table.find(currentEffects, script.Name)
		--		--if ToRemove then
		--		--	table.remove(currentEffects, ToRemove)
		--		--	EnemyConstruct:UpdateEnemy("StatusEffects", currentEffects)
		--		--end
		--	end
		--end
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
		
--		if particle:IsA("Part") then
--			for i2,v2 in pairs(particle:GetChildren()) do
--				if v2:IsA("Attachment") then
--					v2.Parent = EnemyModel:FindFirstChild(v:GetAttribute("Part"))
--					for i3,v3 in pairs(v2:GetChildren()) do
--						if v3:IsA("ParticleEmitter") then
--							v3.Enabled = true
--							table.insert(particles,v3)
--							table.insert(particles,v2)
--						end
--					end
--				end
--			end
--		else
--			particle.Parent = EnemyModel:FindFirstChild(v:GetAttribute("Part"))
--			particle.Enabled = true
--			table.insert(particles,particle)
--		end
--	end
	
--	task.wait(Duration)
	
--	for i,v in particles do
--		v:Destroy()
--	end
--end

return module