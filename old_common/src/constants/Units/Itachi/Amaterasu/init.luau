local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 2, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .3, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})


	local sounds = script.Parent.SFXs
	local effectsfolder = workspace.Effects
	
	SoundWrapper:PlaySound(sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)

	local mangekyo = script.Move1:FindFirstChild("mangekyo"):Clone()
	mangekyo.CFrame = rt.CFrame * CFrame.new(0,0.8,-0.5)
	mangekyo.Parent = effectsfolder
	debris.AddItem(mangekyo,5)


	local Sharingan1 = script.Move1:FindFirstChild("Sharingan1"):Clone()
	Sharingan1.CFrame = rt.CFrame * CFrame.new(0,-1,-2)
	Sharingan1.Parent = effectsfolder
	debris.AddItem(Sharingan1,5)

	local trail = script.Move1:FindFirstChild("trail"):Clone()
	trail.CFrame = rt.CFrame * CFrame.new(0,-1,-1)
	trail.Parent = effectsfolder
	debris.AddItem(trail,5)


	local amaterasu = script.Move1:FindFirstChild("amaterasu"):Clone()
	amaterasu.root.CFrame = pos.CFrame * CFrame.new(0,0,0)
	amaterasu.Parent = effectsfolder
	debris.AddItem(amaterasu,6)

	local ex = script.Move1:FindFirstChild("exp123"):Clone()
	ex.CFrame = pos.CFrame * CFrame.new(0,-0.75,0)
	ex.Parent = effectsfolder
	debris.AddItem(ex,7)

	wait(0.4)


	wait(0.35)


	emit.emitvfx(mangekyo)


	wait(0.3)

	SoundWrapper:PlaySound(sounds["earthpass4"], rt, Replicated.SoundGroups.UnitSFX)

	emit.enablevfx(trail,true)

	emit.emitvfx(Sharingan1)


	local rocketpos = trail.Position
	local enemypos = pos.Position + Vector3.new(0, -1, 0)

	local magnitude = (rocketpos - enemypos).magnitude
	local Step = 40

	local LookAt = CFrame.new(rocketpos, enemypos)

	local Time = math.random(-66, 66) / 100
	local Time2 = math.random(0, 0) / 200
	local ZigZagAmplitude = 2.5  -- Amplitude do movimento de zig zag
	local ZigZagFrequency = 0.1  -- Frequência do movimento de zig zag (menor valor para movimento mais lento)

	spawn(function()
		for i = 1, Step do
			-- Calcule a posição de zig zag com suavidade
			local zigzagX = math.sin(i * ZigZagFrequency) * ZigZagAmplitude * Time
			trail.CFrame = LookAt * CFrame.new(zigzagX, math.sin(math.rad((i * (180 / Step)))) * (5 * Time2), -(magnitude / Step) * (i))
			game:GetService("RunService").Heartbeat:Wait()
		end
		emit.enablevfx(trail,false)
		emit.emitvfx(ex)

		spawn(function()
			local maxSize = 0.055
			-- Defina o tamanho máximo desejado
			local step = 0.01
			local duration = 0.1 -- Defina a duração total do crescimento em segundos

			local numSteps = maxSize / step
			local interval = duration / numSteps

			for i = 1, numSteps do
				local t = i / numSteps
				local smoothScale = t^0.1 * maxSize -- Função de interpolação cúbica
				amaterasu:ScaleTo(smoothScale)
				task.wait(interval)
			end
		end)




		local trail1 = script.Move1.Trail:Clone()
		trail1.Parent = workspace
		trail1.Position = ex.Position
		debris.AddItem(trail1,4)

		tween_service:Create(trail1,TweenInfo.new(1),{Position = trail1.Position + Vector3.new(0,8.5,0)}):Play()
		tween_service:Create(trail1,TweenInfo.new(1),{Orientation = Vector3.new(0,600,0)}):Play()


		SoundWrapper:PlaySound(sounds["fire-ignite4"], rt, Replicated.SoundGroups.UnitSFX)

		SoundWrapper:PlaySound(sounds["magic-cast-heavy03"], ex, Replicated.SoundGroups.UnitSFX)

		emit.enablevfx(trail1,false)

		wait(1.5)

		SoundWrapper:PlaySound(sounds["bless09"], ex, Replicated.SoundGroups.UnitSFX)

		amaterasu:Destroy()

		emit.emitvfx(ex)

		emit.enablevfx(amaterasu,false)


		spawn(function()
			for i = 1,6 do
				local Ground = script.Move1:FindFirstChild("Ground Burst"):Clone()
				Ground.CFrame = ex.CFrame * CFrame.new(math.random(-4,4),math.random(-0.8,-0.8),math.random(-4,4))
				Ground.Parent = effectsfolder
				debris.AddItem(Ground,3.25)
				task.wait(0.05)
				emit.emitvfx(Ground)
			end
		end)


	end)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
