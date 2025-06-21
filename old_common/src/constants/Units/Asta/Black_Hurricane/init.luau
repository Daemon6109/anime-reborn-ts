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
	HitDelay = 1.6, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
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
	local back = unit.back

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local model = script.Move3:FindFirstChild("Model"):Clone()
	model.root.CFrame = rt.CFrame * CFrame.new(0, -1, 0) -- Mantém a posição inicial
	model.Parent = effectsfolder
	debris.AddItem(model, 6)

	local ModelEmit = script.Move3:FindFirstChild("ModelEmit"):Clone()
	ModelEmit.root.CFrame = rt.CFrame * CFrame.new(0, -1, 0) -- Mantém a posição inicial
	ModelEmit.Parent = effectsfolder
	debris.AddItem(ModelEmit, 8)

	local gira = script.Move3:FindFirstChild("gira"):Clone()
	gira.Parent = effectsfolder
	debris.AddItem(gira, 8)

	local Part1 = script.Move3:FindFirstChild("Part1"):Clone()
	Part1.CFrame = rt.CFrame * CFrame.new(0, -1, 0)
	Part1.Parent = effectsfolder
	debris.AddItem(Part1, 5.5)

	wait(0.5)

	emit.enablevfx(Part1,true)


	wait(0.65)

	emit.enablevfx(Part1,false)

	spawn(function()
		local trail1 = script.Move3.Trail:Clone()
		trail1.Parent = effectsfolder
		trail1.Position = rt.Position + Vector3.new(0, -1, 0)
		debris.AddItem(trail1, 4)

		unit.Torso.ENABLE.ParticleEmitter.Enabled = true

		-- Movendo a trilha para frente na direção do olhar
		tween_service:Create(trail1, TweenInfo.new(0.6), {Position = trail1.Position + rt.CFrame.LookVector * 15.5}):Play()
		tween_service:Create(trail1, TweenInfo.new(0.6), {Orientation = Vector3.new(0, 600, 0)}):Play()

		wait(0.5)

		emit.enablevfx(trail1, false)
	end)

	local Part = script.Move3:FindFirstChild("Part"):Clone()
	Part.root.CFrame = rt.CFrame * CFrame.new(0, 0, -22)
	Part.Parent = effectsfolder
	debris.AddItem(Part, 6)

	wait(0.1)

	emit.emitvfx(ModelEmit)

	emit.enablevfx(model, true)

	local rocketpos = model.root.Position
	local enemypos = rt.Position + rt.CFrame.LookVector * -22 -- Aqui estamos usando a direção correta

	local magnitude = (rocketpos - enemypos).magnitude
	local Step = 80

	local Time = math.random(-66, 66) / 100
	local Time2 = math.random(0, 0) / 200
	local ZigZagAmplitude = 2.5
	local ZigZagFrequency = 0.1

	spawn(function()
		for i = 1, Step do
			rt.CFrame = rt.CFrame + rt.CFrame.LookVector * (magnitude / Step) -- Aqui movemos `rt` na direção do olhar
			game:GetService("RunService").Heartbeat:Wait()
		end

		unit.Torso.ENABLE.ParticleEmitter.Enabled = false
	end)

	spawn(function()
		for i = 1, Step do
			model.root.CFrame = model.root.CFrame + model.root.CFrame.LookVector * (magnitude / Step) -- Aqui movemos `model` na direção do olhar
			game:GetService("RunService").Heartbeat:Wait()
		end

		ModelEmit.root.CFrame = model.root.CFrame

		spawn(function()
			local trail1 = script.Move3.Trail:Clone()
			trail1.Parent = effectsfolder
			trail1.Position = model.root.Position + Vector3.new(0, -1, 0)
			debris.AddItem(trail1, 4)

			gira.CFrame = model.root.CFrame

			EmitParticles(gira)

			tween_service:Create(trail1, TweenInfo.new(0.5), {Position = trail1.Position + rt.CFrame.LookVector * 16.5}):Play()
			tween_service:Create(trail1, TweenInfo.new(0.5), {Orientation = Vector3.new(0, 600, 0)}):Play()

			wait(0.4)

			emit.enablevfx(trail1, false)
		end)

		emit.enablevfx(model, false)
		emit.emitvfx(ModelEmit)
	end)

	wait(2.1)

	EmitParticles(Part)

	tween_service:Create(rt, TweenInfo.new(0.2), {CFrame = back.CFrame}):Play()

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
