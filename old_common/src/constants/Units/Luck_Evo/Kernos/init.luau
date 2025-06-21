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
	HitDelay = 1.5, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation4, unit, 1.35, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move4sfx"], rt, Replicated.SoundGroups.UnitSFX)
	local originapos = rt.CFrame

	local aura = script.AuraLightning:Clone()
	aura.Parent = effectsfolder
	aura.CFrame = rt.CFrame * CFrame.new(0,0,0) 
	debris.AddItem(aura,5)

	local magiccircle = script.MagicCircle:Clone()
	magiccircle.Parent = effectsfolder
	magiccircle.CFrame = rt.CFrame * CFrame.new(0,0,2) * CFrame.Angles(math.rad(-90),0,0)
	debris.AddItem(magiccircle,5)

	for _,v in pairs(magiccircle.Small:GetChildren()) do 
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end

	task.wait(0.2)

	for _,v in pairs(magiccircle.Middle:GetChildren()) do 
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end

	task.wait(0.2)

	for _,v in pairs(magiccircle.Big:GetChildren()) do 
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end

	task.wait(0.6)

	local shoot = script.Dash:Clone()
	shoot.Parent = effectsfolder
	shoot.CFrame = rt.CFrame * CFrame.new(0,-0.7,-9) * CFrame.Angles(0,math.rad(90),0)
	for _,s in pairs(shoot:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(shoot,5)

	local orbit = script.Trail:Clone()
	orbit.Main.CFrame = rt.CFrame * CFrame.new(0,1,0) * CFrame.Angles(math.rad(-90),math.rad(90),0)
	orbit.LeftStar.CFrame = rt.CFrame * CFrame.new(4,0,0)  * CFrame.Angles(math.rad(-90),math.rad(90),0)
	orbit.RightStar.CFrame = rt.CFrame * CFrame.new(-4,0,0)* CFrame.Angles(math.rad(-90),math.rad(90),0)
	orbit.Parent = effectsfolder
	debris.AddItem(orbit,5)

	task.delay(0.5, function()
		for _,v in pairs(orbit:GetDescendants()) do 
			if v:IsA("ParticleEmitter") then
				v.Enabled = false
			end
		end
	end)

	task.delay(1.5, function()
		orbit:Destroy()
	end)

	local start = tick()
	local length = 0.3

	coroutine.wrap(function()
		while true do
			orbit:SetPrimaryPartCFrame(orbit:GetPrimaryPartCFrame() * CFrame.fromEulerAnglesXYZ(0, 0.3, 0))
			tween_service:Create(orbit.Main,TweenInfo.new(0.05),{CFrame = orbit.Main.CFrame * CFrame.new(0,2,0)}):Play()
			tween_service:Create(orbit.RightStar,TweenInfo.new(0.05),{CFrame = orbit.RightStar.CFrame * CFrame.new(0,2,0)}):Play()
			tween_service:Create(orbit.LeftStar,TweenInfo.new(0.05),{CFrame = orbit.LeftStar.CFrame * CFrame.new(0,2,0)}):Play()
			task.wait()
			if tick() - start >= length then
				break
			end
		end
	end)()	

	local shooteffect = script.ShootEffect:Clone()
	shooteffect.Parent = workspace
	shooteffect.CFrame = rt.CFrame * CFrame.new(0,0,0) * CFrame.Angles(math.rad(90),0,0)
	for _,s in pairs(shooteffect:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(shooteffect,5)

	aura:Destroy()
	magiccircle:Destroy()

	local vfx = script.xdburst:Clone()
	vfx.Parent = unit
	vfx.CFrame = rt.CFrame * CFrame.Angles(math.rad(90),0,0) * CFrame.new(0,0,-1)
	local weld = Instance.new("WeldConstraint")
	weld.Parent = unit
	weld.Part0 = vfx
	weld.Part1 = unit.HumanoidRootPart
	vfx.Position = rt.Position
	debris.AddItem(vfx,5)
	debris.AddItem(weld,5)

	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame =CFrame.lookAt(pos.Position, pos.Position+SavedDirection)})
	TweenComplete:Play()
	
	task.wait(0.25)
	weld:Destroy()
	for _,v in pairs(vfx:GetDescendants()) do 
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end

	task.wait(0.1)

	local clap = script.Clap:Clone()
	clap.Parent = workspace
	clap.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	for _,s in pairs(clap:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(clap,5)

	local blurshock = script.Blurshock:Clone()
	blurshock.CFrame = clap.CFrame * CFrame.new(0,3,0) * CFrame.Angles(0, math.rad(180), 0)
	blurshock.Parent  = workspace
	debris.AddItem(blurshock,5)

	tween_service:Create(blurshock.SpecialMesh, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
		Scale = Vector3.new(-0.085, -0.05, -0.085),
		Offset = Vector3.new(0, -2.5, 0),
		VertexColor = Vector3.one
	}):Play()

	tween_service:Create(blurshock, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
		Transparency = 1
	}):Play()

	task.wait(.05)

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

	rt.CFrame = startpos
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
