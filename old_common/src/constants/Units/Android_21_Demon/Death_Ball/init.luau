local module = {}
local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)
local vfx_custom = require(Replicated:WaitForChild("Libs"):WaitForChild("VFX_Custom"))
local Run = game:GetService("RunService")

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local Animations = script
local Sound = script.Parent:WaitForChild("Sound")
local Mesh = script.Mesh
local Scaler = require(Replicated.Libs.VFX_Scale)
local effectsfolder = workspace.Effects

module.config = {
	HitDelay = 2.5, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
	Speed = 65,
	--CustomDelay = {
	--	[1] = .35,
	--},
	ScaleFactor = 1,
}

Scaler:scale(module.config.ScaleFactor, Mesh)

local function SetParticlesEnabled(part, shouldEnable)
	for i, v in ipairs(part:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v.Enabled = shouldEnable
				end
			end)()
		end
	end
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
	
	local back = unit.back
	local hum = unit:FindFirstChild("Humanoid")
	local SavedDirection = rt.CFrame.LookVector
	local Enemy = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)

	back.CFrame = CFrame.new(back.Position, pos.Position)

	local function movehere3()
		local animation = AnimModule.PlayAnim(Animations["Animation3"], unit, 1, "", {Weight = 2, Fade = .15})

		local gr = Mesh.gr:Clone()
		gr.CFrame = rt.CFrame * CFrame.new(0,-1.3,0)
		gr.Parent = effectsfolder
		debris.AddItem(gr,4)

		EmitParticles(gr)

		local MainBox = Mesh.MainBox:Clone()
		MainBox.CFrame = rt.CFrame * CFrame.new(0,-1.35,0)
		MainBox.Parent = effectsfolder
		debris.AddItem(MainBox,6)

		wait(0.4)
		SoundWrapper:PlaySound(Sound["earthpass1"], rt, Replicated.SoundGroups.UnitSFX)
		wait(0.1)

		local kiball = Mesh.kiball:Clone()
		kiball.FireBall.CFrame = rt.CFrame * CFrame.new(-1,3.5,0)
		kiball.Parent = effectsfolder
		debris.AddItem(kiball,6)


		local emits = Mesh.emits:Clone()
		emits.CFrame = rt.CFrame * CFrame.new(-1,3.5,0)
		emits.Parent = effectsfolder
		debris.AddItem(emits,6)

		local dash = Mesh.dash:Clone()
		dash.Parent = effectsfolder
		debris.AddItem(dash,6)


		local move = Mesh.move:Clone()
		move.Parent = effectsfolder
		debris.AddItem(move,6)
		SoundWrapper:PlaySound(Sound["magic-charge06"], rt, Replicated.SoundGroups.UnitSFX)
		wait(0.3)
		SoundWrapper:PlaySound(Sound["magic-charge03"], rt, Replicated.SoundGroups.UnitSFX)


		EmitParticles(emits)

		SetParticlesEnabled(MainBox,true)

		spawn(function()

			local maxSize = 1
			local step = 0.01
			local duration = 0.2 

			local numSteps = maxSize / step
			local interval = duration / numSteps

			for i = 1, numSteps do
				local t = i / numSteps
				local smoothScale = t^0.2 * maxSize 
				kiball:ScaleTo(smoothScale)
				task.wait(interval)
			end

		end)


		tween_service:Create(kiball.FireBall, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = rt.CFrame * CFrame.new(-1,8,0)}):Play()

		tween_service:Create(kiball.FireBall, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Transparency = 0}):Play()

		tween_service:Create(kiball.FireBall.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 18}):Play()

		SetParticlesEnabled(kiball,true)

		spawn(function()
			for i = 1,20 do
				local kiblast = Mesh:FindFirstChild("Kiblast1"):Clone()
				kiblast.CFrame = kiball.FireBall.CFrame * CFrame.new(math.random(-25,25),math.random(-25.5,25.5),math.random(-25,25))
				kiblast.Parent = effectsfolder
				debris.AddItem(kiblast,2)
				local rocketpos = kiblast.Position
				local enemypos = kiball.FireBall.Position 
				local magnitude = (rocketpos-enemypos).magnitude
				local Step = 15
				local LookAt = CFrame.new(rocketpos,enemypos)
				local Time = math.random(-125,125)/100
				local Time2 = math.random(-125,125)/200
				spawn(function()
					for i = 1,Step do
						kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
						game:GetService("RunService").Heartbeat:Wait()
					end
				end)
				task.wait(0.045)
			end
		end)



		wait(1)

		dash.CFrame = rt.CFrame * CFrame.new(0,8,0)
		dash.CFrame = CFrame.new(dash.Position, pos.Position)

		EmitParticles(dash)

		tween_service:Create(kiball.FireBall, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = pos.CFrame}):Play()

		SoundWrapper:PlaySound(Sound["Polaron Beam"], rt, Replicated.SoundGroups.UnitSFX)


		wait(0.4)

		SoundWrapper:PlaySound(Sound["explosion03"], rt, Replicated.SoundGroups.UnitSFX)

		move.CFrame = pos.CFrame * CFrame.new(0,-1.3,0)

		tween_service:Create(kiball.FireBall, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Transparency = 1}):Play()


		tween_service:Create(kiball.FireBall.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 0}):Play()


		SetParticlesEnabled(kiball,false)


		SetParticlesEnabled(MainBox,false)


		EmitParticles(move)

	end
	movehere3()
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
