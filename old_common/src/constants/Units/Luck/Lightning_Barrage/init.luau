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
	HitDelay = .75, -- seconds
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





function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	local floorslam = script.Jump:Clone()
	floorslam.Parent = effectsfolder
	floorslam.CFrame = rt.CFrame * CFrame.new(0,1,0)
	for _,s in pairs(floorslam:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(floorslam,3)

	local blurshock = script.Blurshock:Clone()
	blurshock.CFrame = rt.CFrame * CFrame.new(0,1,0) * CFrame.Angles(0, math.rad(180), 0)
	blurshock.Parent  = effectsfolder
	debris.AddItem(blurshock,3)

	local swirl = script.Swirl:Clone()
	swirl.CFrame = rt.CFrame * CFrame.new(0,5,0) 
	swirl.Parent  = effectsfolder
	debris.AddItem(swirl,3)

	local mesh = script.Mesh:Clone()
	mesh.Parent = effectsfolder
	mesh.CFrame = rt.CFrame * CFrame.new(0,2,0) * CFrame.Angles(0,0,0)
	tween_service:Create(mesh, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
		Size = Vector3.new(0, 20.484, 0),
	}):Play()
	debris.AddItem(mesh,3)

	task.delay(0.2, function()
		mesh:Destroy()
	end)

	tween_service:Create(blurshock.SpecialMesh, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
		Scale = Vector3.new(-0.050, -0.05, -0.050),
		Offset = Vector3.new(0, -2.5, 0),
		VertexColor = Vector3.one
	}):Play()

	tween_service:Create(blurshock, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
		Transparency = 1
	}):Play()

	tween_service:Create(swirl, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
		Size = Vector3.new(25, 8, 25),
		Transparency = 1,
		CFrame = swirl.CFrame * CFrame.new(0, -2, 0) * CFrame.Angles(0, math.rad(-90), 0)
	}):Play()

	tween_service:Create(rt,TweenInfo.new(0.3),{CFrame = rt.CFrame * CFrame.new(0,10,0)}):Play()


	task.wait(0.2)


	local shooteffect = script.ShootEffect:Clone()
	shooteffect.CFrame = rt.CFrame * CFrame.new(0.6,0,-1) * CFrame.Angles(math.rad(90),0,0)
	shooteffect.Parent = effectsfolder
	debris.AddItem(shooteffect,3)

	rt.Anchored = true

	local start = tick()
	local length = 1

	coroutine.wrap(function()
		while true do

			for _,s in pairs(shooteffect:GetDescendants()) do
				if s:IsA("ParticleEmitter") then
					s:Emit(s.Rate)
				end
			end


			local projectile = script.Projectile:Clone()
			projectile.CFrame = shooteffect.CFrame * CFrame.new(0,0,0) * CFrame.Angles(0,math.rad(90),0)
			projectile.Parent = effectsfolder
			debris.AddItem(projectile,3)

			task.delay(1, function()
				projectile:Destroy()
			end)

			local TweenComplete = tween_service:Create(projectile,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame =CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + Vector3.new(math.random(-5,5),-1,math.random(-5,5))})
			TweenComplete:Play()
	

			task.delay(0.2, function()
				for _,v in pairs(projectile:GetDescendants()) do 
					if v:IsA("ParticleEmitter") then
						v.Enabled = false
					end
				end
				local explosion = script.SmallExplosion:Clone()
				explosion.CFrame = projectile.CFrame * CFrame.Angles(math.rad(90),0,math.rad(90))
				explosion.Parent = effectsfolder
				for _,s in pairs(explosion:GetDescendants()) do
					if s:IsA("ParticleEmitter") then
						s:Emit(s.Rate)
					end
				end
				debris.AddItem(explosion,3)

			end)
			task.wait(0.1)
			if tick() - start >= length then
				break
			end
		end
	end)()
	
	task.wait(1.15)
	local tpeffect = script.TpEffect:Clone()
	tpeffect.Parent = effectsfolder
	tpeffect.CFrame = rt.CFrame
	for _,s in pairs(tpeffect:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(tpeffect,5)

	task.wait(0.05)

	rt.CFrame =startpos
	local tpeffect = script.TpEffect:Clone()
	tpeffect.Parent = effectsfolder
	tpeffect.CFrame = rt.CFrame
	for _,s in pairs(tpeffect:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(tpeffect,5)
	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
