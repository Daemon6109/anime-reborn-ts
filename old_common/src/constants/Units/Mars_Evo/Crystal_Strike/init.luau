local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

module.config = {
	HitDelay = 2.15, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .42, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

local function EmitParticles(part)
	for i,v in part:GetDescendants() do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v:Emit(v:GetAttribute("EmitCount"))
				end 

				local _delay = v:GetAttribute("EmitDuration")
				if _delay then
					v.Enabled = true
					task.delay(_delay, function()
						v.Enabled = false
					end)
				end
			end)()
		end
	end
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local emitss = script.Move3:FindFirstChild("emitsaa"):Clone()
	emitss.Parent = effectsfolder
	debris.AddItem(emitss,5)
	emitss.root.CFrame = rt.CFrame * CFrame.new(0,-1,0)

	EmitParticles(emitss)

	wait(1.4)


	for i = 1,5 do

		local numberOfSpikes = 8 -- Número de IceSpikes
		local radius = 4 -- Raio do círculo
		local angleStep = math.rad(360 / numberOfSpikes) -- Divisão do círculo em partes iguais

		-- Função para criar uma IceSpike
		local function createIceSpike(angle)
			local part1 = Instance.new("Part")
			part1.CFrame = rt.CFrame * CFrame.new(0,2,1)
			part1.Size = Vector3.new()
			part1.Transparency = 0
			part1.Anchored = true
			part1.CanCollide = false
			part1.CanTouch = false
			debris.AddItem(part1)

			-- Calcula a posição circular ao longo dos eixos X e Y
			local offsetX = math.sin(angle) * radius -- Posição ao longo do eixo X
			local offsetY = math.cos(angle) * radius -- Posição ao longo do eixo Y
			local spawnPosition = part1.CFrame * CFrame.new(offsetX, offsetY, 2) -- Z é fixado em 0

			-- Cria o IceSpike
			local Icespike1 = script.Move3:FindFirstChild("IceSpike1"):Clone()
			Icespike1.Part.CFrame = spawnPosition -- A posição agora está ajustada nos eixos X e Y

			local Part = script.Move3:FindFirstChild("Part"):Clone()
			Part.CFrame = Icespike1.Part.CFrame
			Part.Parent = effectsfolder
			debris.AddItem(Part,5)


			-- Ajustar direção para frente (não para o ponto "pos")
			local forwardDirection = Icespike1.Part.CFrame.LookVector
			local lookAtCFrame = Icespike1.Part.CFrame * CFrame.new(forwardDirection * 0.1) -- Se mover para frente

			-- Aplica a rotação para olhar para frente
			Icespike1.Part.CFrame = lookAtCFrame

			Icespike1.Parent = effectsfolder
			debris.AddItem(Icespike1, 5)

			-- Configura efeitos ao spawnar
			EmitParticles(Icespike1.Part)
			tween_service:Create(Icespike1.Part.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Range = 6}):Play()
			tween_service:Create(Icespike1.Shard, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(0.329, 5.364, 0.256)}):Play()
			tween_service:Create(Icespike1.ShardNeon, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(0.237, 5.328, 0.316)}):Play()

			for _, v in pairs(Icespike1.Shard.Beam:GetChildren()) do
				if v:IsA("Beam") then
					tween_service:Create(v, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 1.5}):Play()
				end
			end

			emit.enablevfx(Icespike1.Shard, true)

			EmitParticles(Part)





			wait(0.3)

			EmitParticles(Part)

			-- Movimenta a IceSpike para frente
			local tween = tween_service:Create(
				Icespike1.Part,
				TweenInfo.new(0.09, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
				{CFrame = Icespike1.Part.CFrame + forwardDirection * 15} -- Move para frente
			)
			tween:Play()

			-- Atualiza a orientação enquanto se move
			tween.Completed:Connect(function()
				tween_service:Create(
					Icespike1.Part,
					TweenInfo.new(0.09, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{CFrame = Icespike1.Part.CFrame + forwardDirection * 15}
				):Play()
			end)

			spawn(function()
				wait(0.1)

				local Part1 = script.Move3:FindFirstChild("Part1"):Clone()
				Part1.CFrame = Icespike1.Part.CFrame
				Part1.Parent = effectsfolder
				debris.AddItem(Part1,5)

				EmitParticles(Part1)

				emit.enablevfx(Icespike1.Shard, false)
				tween_service:Create(Icespike1.Part.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Range = 0}):Play()
				tween_service:Create(Icespike1.Shard, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new()}):Play()
				tween_service:Create(Icespike1.ShardNeon, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new()}):Play()

				for _, v in pairs(Icespike1.Shard.Beam:GetChildren()) do
					if v:IsA("Beam") then
						tween_service:Create(v, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
					end
				end
			end)
		end

		-- Spawn dos IceSpikes em sequência
		for i = 0, numberOfSpikes - 1 do
			task.spawn(function()
				local angle = angleStep * i -- Ângulo atual para a posição do spike
				createIceSpike(angle)
			end)
			wait(0.025) -- Intervalo entre cada spawn
		end


	end
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
