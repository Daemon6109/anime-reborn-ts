local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local Sounds = script

module.config = {
	HitDelay = .6, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .5, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})

	local effectsfolder = workspace.Effects
	
	
	local magic = script.magic:Clone()    
	magic.rootpart.CFrame = rt.CFrame * CFrame.new(0,11,0)
	magic.Parent = effectsfolder
	debris.AddItem(magic,8)

	local stars = script.stars:Clone()    
	stars.CFrame = rt.CFrame * CFrame.new(0,11,0)
	stars.Parent = effectsfolder
	debris.AddItem(stars,8)


	local dashata = script.dashata:Clone()    
	dashata.CFrame = rt.CFrame * CFrame.new(0,-1.25,0)
	dashata.Parent = effectsfolder
	debris.AddItem(dashata,4)

	for _, v in ipairs(unit.wings:GetDescendants()) do
		if v:IsA("MeshPart") then
			tween_service:Create(v, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(0)}):Play()
		end
	end

	SoundWrapper:PlaySound(Sounds["flystart"], rt, Replicated.SoundGroups.UnitSFX)

	wait()

	for _, v in ipairs(unit.wings:GetDescendants()) do
		if v:IsA("MeshPart") then
			tween_service:Create(v, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
		end
	end

	tween_service:Create(unit.wings.aa, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(1.317, 1.838, 3.742)}):Play()
	tween_service:Create(unit.wings.bb, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(1.317, 1.838, 3.742)}):Play()
	tween_service:Create(unit.wings.cc, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(1.267, 1.719, 3.672)}):Play()
	tween_service:Create(unit.wings.dd, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(1.267, 1.719, 3.672)}):Play()
	emit.emitvfx(unit.Torso.emitwings)

	emit.enablevfx(unit.Torso.ativ,true)

	emit.enablevfx(unit.Torso.ativ2,true)

	wait(0.3)

	emit.emitvfx(dashata)
	tween_service:Create(rt, TweenInfo.new(1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = rt.CFrame * CFrame.new(0,15,0)}):Play()

	wait(1.15)

	SoundWrapper:PlaySound(Sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)

	wait(0.35)


	emit.emitvfx(stars)

	tween_service:Create(magic.rootpart.PointLight, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 16}):Play()

	emit.enablevfx(magic,true)

	emit.emitvfx(unit.Torso.emit)

	SoundWrapper:PlaySound(Sounds["magic-cast-b03"], rt, Replicated.SoundGroups.UnitSFX)

	spawn(function()
		local maxSize = 2 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.2 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.2 * maxSize -- Função de interpolação cúbica
			magic:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)


	wait(0.3)
	local back = unit.back

	local p1 = script:FindFirstChild("Part1"):Clone()
	p1.CFrame = back.CFrame * CFrame.new(0,13.5,-1.5)
	p1.Parent = effectsfolder
	debris.AddItem(p1,6)
	emit.emitvfx(p1)
	tween_service:Create(p1, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Vector3.new(.5,.5,.5)}):Play()
	spawn(function()
		wait(1.75)
		local ss = script:FindFirstChild("SignleWithGau"):Clone()
		ss.CFrame = rt.CFrame * CFrame.new(0,0.5,0)
		ss.Parent = effectsfolder
		debris.AddItem(ss,6)
		emit.emitvfx(ss)
		SoundWrapper:PlaySound(Sounds["Dragon-Ball-Z-Punch-Sound-Effect-N°9"], rt, Replicated.SoundGroups.UnitSFX)
		SoundWrapper:PlaySound(Sounds["pain-toxic"], rt, Replicated.SoundGroups.UnitSFX)
		tween_service:Create(p1, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Vector3.new()}):Play()
	end)
	wait(0.15)
	spawn(function()
		for i = 1,20 do

			task.wait(0.0165)

			spawn(function()
				local p = script:FindFirstChild("Part1"):Clone()
				p.CFrame = p1.CFrame
				p.Parent = effectsfolder
				debris.AddItem(p,8)
				tween_service:Create(p, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Vector3.new(.35,.35,.35)}):Play()

				task.wait()

				tween_service:Create(p, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = back.CFrame * CFrame.new(math.random(-22,22),math.random(22,23),math.random(-22,22))}):Play()

				wait(0.4)
				local un = script:FindFirstChild("untitled"):Clone()
				un.Sphere.CFrame = p.CFrame
				un.Parent = effectsfolder
				debris.AddItem(un,8)
				wait(0.1)
				un.Sphere.Size = Vector3.new()
				un.Part.Size = Vector3.new()

				tween_service:Create(un.Sphere, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Vector3.new(2.025,0.708,2.025)}):Play()
				tween_service:Create(un.Part, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Vector3.new(0.3, 0.3, 0.3)}):Play()

				un.AnimationController:LoadAnimation(AnimModule.GetAnim(script.slimes)):Play()
				
				emit.emitvfx(un.Sphere.Attachment1)

				task.wait(0.01)

				SoundWrapper:PlaySound(Sounds["Water Splash Sound"], rt, Replicated.SoundGroups.UnitSFX)

				un.Sphere.Transparency = 0
				un.Part.Transparency = 0

				task.wait(0.025)

				tween_service:Create(un.Part.Attachment1.Beam, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0.05, Width1 = 0.05}):Play()
				un.Part.Anchored = true

				spawn(function()
					wait(0.3)
					tween_service:Create(p, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Vector3.new()}):Play()

					tween_service:Create(un.Part, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = un.Sphere.CFrame * CFrame.new(0,-0.7,0)}):Play()

				end)

				spawn(function()
					wait(0.6)

					for i = 1,11 do
						task.wait(0.2)
						un.Part.Attachment1.ParticleEmitter:Emit(1)

						local trail = script:FindFirstChild("trails"):Clone()
						trail.CFrame = un.Part.CFrame
						trail.Parent = effectsfolder
						debris.AddItem(trail,2)
						spawn(function()
							task.wait(0.001)
							SoundWrapper:PlaySound(Sounds["swoosh-short3"], rt, Replicated.SoundGroups.UnitSFX)
							tween_service:Create(trail, TweenInfo.new(0.075, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = back.CFrame * CFrame.new(math.random(-20,20),math.random(-1.7,-1.7),math.random(-20,20))}):Play()
							wait(0.1)
							emit.emitvfx(trail.Attachment1)
							emit.enablevfx(trail,false)

						end)
					end

				end)
				spawn(function()
					wait(3.8)
					tween_service:Create(un.Part.Attachment1.Beam, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
					tween_service:Create(un.Part, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Vector3.new(0),Transparency = 1}):Play()
					tween_service:Create(un.Sphere, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Vector3.new(0),Transparency = 1}):Play()
				end)
			end)

		end

	end)

	wait(1.4)

	tween_service:Create(magic.rootpart.PointLight, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 0}):Play()

	emit.enablevfx(magic,false)
	wait(1.3)
	tween_service:Create(rt, TweenInfo.new(0.7, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = back.CFrame}):Play()

	local dashata1 = script.dashata1:Clone()    
	dashata1.CFrame = back.CFrame * CFrame.new(0,-1,0)
	dashata1.Parent = effectsfolder
	debris.AddItem(dashata1,3.5)
	emit.emitvfx(dashata1)

	wait(0.8)

	SoundWrapper:PlaySound(Sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)


	emit.enablevfx(unit.Torso.ativ,false)

	emit.enablevfx(unit.Torso.ativ2,false)

	for _, v in ipairs(unit.wings:GetDescendants()) do
		if v:IsA("MeshPart") then
			tween_service:Create(v, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(0)}):Play()
		end
	end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
