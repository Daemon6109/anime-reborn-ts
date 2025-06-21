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
	HitDelay = 3.55, -- seconds
	Duration = .8,
	TurnTime = .7,
	StunTime = 4,
	AttackRange = 25,
	AttackSize = 15,
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

for i,v in script:GetDescendants() do
	if v:IsA("BasePart") and not v:HasTag("NoAnchor") then
		v.Anchored = true
	end
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	task.spawn(function()
		task.wait(1.5)
		SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

	end)	
	for i = 1, 6 do
		task.wait(0.15)

		spawn(function()
			task.wait(1.4)

			-- Configuração para as posições fixas
			local positions = {
				Vector3.new(5, 5, 1), -- Direita superior
				Vector3.new(5, 0, -2), -- Direita meio
				Vector3.new(5, 1, 2), -- Direita inferior
				Vector3.new(-5, 5, -1), -- Esquerda superior
				Vector3.new(-5, 0, 2), -- Esquerda meio
				Vector3.new(-5, 1, -2) -- Esquerda inferior
			}

			local posIndex = i -- Escolhe a posição com base no índice do loop

			local balls = script.Attack2:FindFirstChild("balls"):Clone()
			balls.Parent = effectsfolder
			balls.root.CFrame = rt.CFrame * CFrame.new(positions[posIndex])
			debris.AddItem(balls, 6)

			local aaaaaa = script.Attack2:FindFirstChild("aaaaaa"):Clone()
			aaaaaa.Parent = effectsfolder
			aaaaaa.CFrame = balls.root.CFrame
			debris.AddItem(aaaaaa, 6)
			EmitParticles(aaaaaa)

			-- Flutuação suave para cima e para baixo
			spawn(function()
				local startTime = os.clock()
				local duration = 1.51 -- duração da flutuação em segundos
				local amplitude = 0.03 -- altura máxima de flutuação
				while os.clock() - startTime < duration do
					local elapsed = os.clock() - startTime
					local offset = math.sin(elapsed * math.pi * 1) * amplitude
					balls.root.CFrame = balls.root.CFrame * CFrame.new(0, offset, 0)
					task.wait(0.01) -- controle da taxa de atualização
				end
			end)

			-- Crescimento do tamanho das balls
			spawn(function()
				local maxSize = 0.8 -- tamanho máximo
				local step = 0.01
				local duration = 0.25 -- duração total do crescimento

				local numSteps = maxSize / step
				local interval = duration / numSteps

				for i = 1, numSteps do
					local t = i / numSteps
					local smoothScale = t ^ 0.25 * maxSize -- função de interpolação cúbica
					balls:ScaleTo(smoothScale)
					task.wait(interval)
				end
			end)

			task.wait(1.5)

			local rocketpos = balls.root.Position
			local enemypos = pos.Position + Vector3.new(math.random(-6, 6), math.random(1, 6), math.random(-6, 6))
			local magnitude = (rocketpos - enemypos).magnitude
			local Step = 34
			local LookAt = CFrame.new(rocketpos, enemypos)
			local Time = math.random(-77, 77) / 100
			local Time2 = math.random(-77, 77) / 200

			spawn(function()
				for i = 1, Step do
					balls.root.CFrame = LookAt * CFrame.new(
						math.sin(math.rad((i * -(180 / Step)))) * (15 * Time),
						math.sin(math.rad((i * (180 / Step)))) * (5 * Time2),
						-(magnitude / Step) * (i)
					)
					game:GetService("RunService").Heartbeat:Wait()
				end

				local ex = script.Attack2:FindFirstChild("EXP"):Clone()
				ex.Parent = effectsfolder
				ex.CFrame = balls.root.CFrame * CFrame.new(0, 0, 0)
				ex.Orientation = Vector3.new()
				debris.AddItem(ex, 4)
				EmitParticles(ex)

				balls:Destroy()
			end)
		end)
	end
	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
