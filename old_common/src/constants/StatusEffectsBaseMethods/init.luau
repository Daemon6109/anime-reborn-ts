local module = {}

local Replicated = game:GetService("ReplicatedStorage")
local debris = require(Replicated.Libs.DebrisSystemV2)
local Events = Replicated.Events


module.EnemiesCDs = {}
module.EffectCooldown = 1
module.Stackable = false

function module:SendInfoToClient(Unit, Enemies, Duration)
	Events.StatusEffect:FireAllClients(self.Root.Name, Unit, module:GetEnemyIDs(Enemies), Duration)
end

function module:SendInfoToClientDOT(Unit, Enemies, Duration, DotTable)
	Events.StatusEffect:FireAllClients(self.Root.Name, Unit, module:GetEnemyIDs(Enemies), Duration)

	if DotTable then
		Events.VisualEffects:FireAllClients("DotDamageClient", nil, nil, Unit, module:GetEnemyIDs(Enemies), DotTable)
	end
end

--Legacy + unused
--function module:SendInfoToClientWithAbilityDelay(Unit, Enemies, Duration, DotTable) 
--	local VFXModule = require(_G.Registry.registry.Units[Unit.Name].misc.ScriptLink[Unit.configuration.Ability.Value])
	
--	task.delay(0 --[[VFXModule.config.HitDelay]],function()
--		Events.StatusEffect:FireAllClients(self.Root.Name, Unit, module:GetEnemyIDs(Enemies), Duration)
		
--		if DotTable then
--			Events.VisualEffects:FireAllClients("DotDamageClient", nil, nil, nil, module:GetEnemyIDs(Enemies), DotTable)
--		end
--	end)
--end

function module:GetEnemyIDs(Enemies)
	local EnemiesIDs = {}

	for i, NpcData in ipairs(Enemies) do
		if NpcData then
			table.insert(EnemiesIDs,NpcData.EnemyID)
		end
	end
	
	return EnemiesIDs
end

function module:GetEnemyConstructs(Enemies)
	local Table = {}
	
	for i,enemy in Enemies do
		if enemy.npcId then
			table.insert(Table,enemy.npc)
		else
			table.insert(Table,enemy)
		end
	end
	
	return Table
end

function module:RemoveEnemiesOnCD(Constructs)
	local Table = {}
	
	local T = tick()
	
	for i,construct in Constructs do
		if not self.Stackable then
			if not self.EnemiesCDs[construct.EnemyID] then
				table.insert(Table,construct)
			else
				if self.EnemiesCDs[construct.EnemyID] < T then
					table.insert(Table,construct)
					self.EnemiesCDs[construct.EnemyID] = nil
				end
			end
		else
			return Constructs
		end
	end
	
	return Table
end

function module:RemoveEnemiesWithSlowImmunity(Constructs)
	local Table = {}

	for i,construct in Constructs do
		if not construct.SlowdownImmunity then
			table.insert(Table, construct)
		end
	end

	return Table
end

function module:AddEnemiesCD(Constructs,Duration)
	for i,construct in Constructs do
		self.EnemiesCDs[construct.EnemyID] = tick()+Duration+self.EffectCooldown
	end
	
	for i,EnemyConstruct in Constructs do
		local currentEffects = EnemyConstruct.StatusEffects
		currentEffects[self.Root.Name] = true
		EnemyConstruct:UpdateEnemy("StatusEffects", currentEffects)
	end
	
	if Duration > 5000 then
		return
	end
	
	task.delay(Duration, function()
		for i,EnemyConstruct in Constructs do
			if EnemyConstruct and EnemyConstruct.Health > 0 then
				local currentEffects = EnemyConstruct.StatusEffects
				currentEffects[self.Root.Name] = nil
				EnemyConstruct:UpdateEnemy("StatusEffects", currentEffects)
			end
		end
	end)
	
	task.delay(Duration+self.EffectCooldown, function() -- <3
		for i,EnemyConstruct in Constructs do
			self.EnemiesCDs[EnemyConstruct.EnemyID] = nil
		end
	end)
end

function module:OnServer(Unit, Enemies, Duration)
	return
end

function module:OnClient(Unit, Enemies, Duration)
	for i, NpcData in ipairs(Enemies) do
		if NpcData then
			local NPCModel = workspace.NPC_Client_Models:FindFirstChild(NpcData)
				
			if not NPCModel then return end
			
			task.spawn(function()
				self:VFXandAnim(NPCModel, Duration)
			end)
			
			local NPCHead = NPCModel:FindFirstChild("Head")
			
			if not NPCHead then return end
			
			local StatusEffectGUI = NPCHead:FindFirstChild("NPCOverhead")
			
			local Effect:ImageLabel = self.Root.Status:Clone()
			
			if Effect:IsA("TextLabel") then
				Effect.Parent = StatusEffectGUI.TextEffects
			else
				Effect.Parent = StatusEffectGUI.TextEffects.IconEffects
			end
			
			--debris.AddItem(Effect,Duration)
			
			task.delay(Duration, function()
				if Effect:IsA("ImageLabel") then
					Effect.ImageColor3 = Color3.new(Effect.ImageColor3.R/3, Effect.ImageColor3.G/3, Effect.ImageColor3.B/3)
					debris.AddItem(Effect, self.EffectCooldown)
				else
					Effect:Destroy()
				end
			end)
		end
	end
end

function module:VFXandAnim(EnemyModel, Duration)
	if not _G.ClientSettings.StatusEffectVFX then return end
	
	if not _G.SharedParticleCache then
		_G.SharedParticleCache = {}
	end
	
	if not _G.SharedParticleCache[EnemyModel.Name] then
		_G.SharedParticleCache[EnemyModel.Name] = {}
	end
	
	local EnemyFold = workspace.NPC:FindFirstChild(EnemyModel.Name)
	
	if not EnemyFold then return end
	if not EnemyFold.Alive.Value then return end
	
	if not self.Cached then
		self.Cached = {}
		
		for i,v in pairs(self.Root.Particles:GetChildren()) do
			local particle = v

			if particle:IsA("Part") then
				for i2,v2 in pairs(particle:GetChildren()) do
					if v2:IsA("Attachment") then
						table.insert(self.Cached, v2)
						for i3,v3 in pairs(v2:GetDescendants()) do
							if v3:IsA("ParticleEmitter") or v3:IsA("Beam") then
								table.insert(self.Cached, v3)
							end
						end
					end
				end
			else
				table.insert(self.Cached, particle)
			end
		end
	end
	
	for i, v in self.Cached do
		local FoundPartParent = v:GetAttribute("Part")
		
		if not FoundPartParent or FoundPartParent ~= "Torso" then
			continue
		end
		
		local particle = v:Clone()
		
		if particle:IsA("ParticleEmitter") then
			particle.Enabled = true
			particle.Rate = particle.Rate/1.75
		elseif particle:IsA("Beam") then
			particle.Enabled = true
		end

		local HasPart = EnemyModel:FindFirstChild(FoundPartParent)

		if not HasPart then
			particle:Destroy()
			continue
		end

		particle.Parent = HasPart
		table.insert(_G.SharedParticleCache[EnemyModel.Name],particle)
	end
	
	--for i,v in pairs(self.Root.Particles:GetChildren()) do
	--	local particle = v:Clone()

	--	if particle:IsA("Part") then
	--		for i2,v2 in pairs(particle:GetChildren()) do
	--			if v2:IsA("Attachment") then
	--				v2.Parent = EnemyModel:FindFirstChild(v2:GetAttribute("Part"))
	--				for i3,v3 in pairs(v2:GetDescendants()) do
	--					if v3:IsA("ParticleEmitter") or v3:IsA("Beam") then
	--						v3.Enabled = true
	--						table.insert(_G.SharedParticleCache[EnemyModel.Name],v3)
	--						table.insert(_G.SharedParticleCache[EnemyModel.Name],v2)
	--					end
	--				end
	--			end
	--		end
	--	else
	--		particle.Rate = particle.Rate/5
	--		particle.Parent = EnemyModel:FindFirstChild(v:GetAttribute("Part"))
	--		particle.Enabled = true
	--		table.insert(_G.SharedParticleCache[EnemyModel.Name],particle)
	--	end
	--end

	task.wait(Duration)

	if _G.SharedParticleCache[EnemyModel.Name] then
		for i,v in _G.SharedParticleCache[EnemyModel.Name] do
			if v and v.Parent then
				v:Destroy()
			end
		end
	end
end

return module
