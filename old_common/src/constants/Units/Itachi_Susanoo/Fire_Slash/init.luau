local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 2.4, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
}




function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation5, unit, 1, "", {Weight = 2, Fade = .15})


	local sounds = script.Parent.SFXs
	local effectsfolder = workspace.Effects

	local mangekyo = script.Move5:FindFirstChild("mangekyo"):Clone()
	mangekyo.CFrame = rt.CFrame * CFrame.new(0,0.8,-0.5)
	mangekyo.Parent = effectsfolder
	debris.AddItem(mangekyo,3)

	local explosionfire1 = script.Move5:FindFirstChild("explosionfire1"):Clone()
	explosionfire1.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	explosionfire1.Parent = effectsfolder
	debris.AddItem(explosionfire1,12.25)

	local explosionfire = script.Move5:FindFirstChild("explosionfire"):Clone()
	explosionfire.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	explosionfire.Parent = effectsfolder
	debris.AddItem(explosionfire,12.35)

	SoundWrapper:PlaySound(sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(0.5)

	SoundWrapper:PlaySound(sounds["Sharingan Activate (NOT MONGEKYO)"], rt, Replicated.SoundGroups.UnitSFX)

	wait(0.15)


	emit.emitvfx(mangekyo)

	task.wait(0.3)


	SoundWrapper:PlaySound(sounds["Flame Licks 9 (SFX)"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(explosionfire)



	emit.emitvfx(explosionfire)

	SoundWrapper:PlaySound(sounds["fire-ignite4"], rt, Replicated.SoundGroups.UnitSFX)



	task.wait(0.015)

	local mozsusano = script.Move5:FindFirstChild("mozsusano"):Clone()
	mozsusano.RootPart.CFrame = rt.CFrame * CFrame.new(0,-2,0)
	mozsusano.Parent = effectsfolder
	debris.AddItem(mozsusano,7.25)

	local MainBox = script.Move5:FindFirstChild("MainBox"):Clone()
	MainBox.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	MainBox.Parent = effectsfolder
	debris.AddItem(MainBox,5)



	
	
	local m1 = script.Move5:FindFirstChild("1"):Clone()
	m1.CFrame = startpos + (startpos.LookVector * 6) + Vector3.new(0,-1.5,0)
	m1.Parent = effectsfolder
	debris.AddItem(m1,5)
	local m2 = script.Move5:FindFirstChild("2"):Clone()
	m2.CFrame = startpos + (startpos.LookVector * 12) + Vector3.new(0,-1.5,0)
	m2.Parent = effectsfolder
	debris.AddItem(m2,5)
	local m3 = script.Move5:FindFirstChild("4"):Clone()
	m3.CFrame = startpos + (startpos.LookVector * 22) + Vector3.new(0,-1.5,0)
	m3.Parent = effectsfolder
	debris.AddItem(m3,5)
	
	local Model1 = script.Move5:FindFirstChild("model1"):Clone()
	Model1.root.CFrame = rt.CFrame * CFrame.new(0,-1,-10)
	debris.AddItem(Model1,5)
	Model1.Parent = effectsfolder
	
	local m12 = script.Move5:FindFirstChild("3"):Clone()
	m12.CFrame = startpos + (startpos.LookVector * 22) + Vector3.new(0,-0.5,0)
	m12.Parent = effectsfolder
	debris.AddItem(m12,5)
	local m22 = script.Move5:FindFirstChild("5"):Clone()
	m22.CFrame = startpos + (startpos.LookVector * 6) + Vector3.new(0,-0.5,0)
	m22.Parent = effectsfolder
	debris.AddItem(m22,5)
	local m32 = script.Move5:FindFirstChild("6"):Clone()
	m32.CFrame = startpos + (startpos.LookVector * 12) + Vector3.new(0,-0.5,0)
	m32.Parent = effectsfolder
	debris.AddItem(m32,5)
	

	emit.enablevfx(MainBox,true)

	local animation = mozsusano.AnimationController:LoadAnimation(AnimModule.GetAnim(script.SusanoLastmove)):Play()

	

	emit.enablevfx(mozsusano,true)

	for i, v in pairs(mozsusano.bb.beam:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.3,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 3,Width1 = 0.5}):Play()
		end
	end

	tween_service:Create(mozsusano.RootPart.PointLight,TweenInfo.new(.015),{Range = 8}):Play()
	tween_service:Create(mozsusano.body,TweenInfo.new(.3),{Transparency = .4}):Play()
	tween_service:Create(mozsusano.face,TweenInfo.new(.3),{Transparency = 0}):Play()

	tween_service:Create(mozsusano.RootPart.a,TweenInfo.new(.15),{Width0 = 45,Width1 = 9}):Play()

	tween_service:Create(mozsusano.RootPart.b,TweenInfo.new(.15),{Width0 = 9,Width1 = 5}):Play()


	local slash = script.Move5:FindFirstChild("slash"):Clone()
	slash.CFrame = rt.CFrame * CFrame.new(0,1,-4)
	slash.Parent = effectsfolder
	debris.AddItem(slash,4.5)

	local ExplosionImpact1 = script.Move5:FindFirstChild("ExplosionImpact1"):Clone()
	ExplosionImpact1.CFrame = rt.CFrame * CFrame.new(0,-0.85,0)
	ExplosionImpact1.Parent = effectsfolder
	debris.AddItem(ExplosionImpact1,6.5)

	SoundWrapper:PlaySound(sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)
	
	
	
	
	wait(.7)


	emit.enablevfx(m1,true)
	emit.enablevfx(m2,true)
	emit.enablevfx(m3,true)

	emit.enablevfx(m12,true)
	emit.enablevfx(m22,true)
	emit.enablevfx(m32,true)

	emit.emitvfx(slash)
	SoundWrapper:PlaySound(sounds["yamato swing"], rt, Replicated.SoundGroups.UnitSFX)



	wait(0.1)

	emit.emitvfx(ExplosionImpact1)


	emit.enablevfx(Model1,true)

	SoundWrapper:PlaySound(sounds["magic-cast-heavy09"], rt, Replicated.SoundGroups.UnitSFX)


	tween_service:Create(Model1.root.Beam,TweenInfo.new(.2),{Width0 = 6,Width1 = 40}):Play()
	wait(1)

	emit.enablevfx(m1,false)
	emit.enablevfx(m2,false)
	emit.enablevfx(m3,false)
	
	emit.enablevfx(m12,false)
	emit.enablevfx(m22,false)
	emit.enablevfx(m32,false)

	emit.emitvfx(m1)
	emit.emitvfx(m2)
	emit.emitvfx(m3)

	emit.emitvfx(m12)
	emit.emitvfx(m22)
	emit.emitvfx(m32)
	
	tween_service:Create(Model1.root.Beam,TweenInfo.new(.2),{Width0 = 0,Width1 = 0}):Play()

	emit.enablevfx(Model1,false)

	wait(0.1)

	SoundWrapper:PlaySound(sounds["fire-ignite4"], rt, Replicated.SoundGroups.UnitSFX)

	tween_service:Create(mozsusano.RootPart.PointLight,TweenInfo.new(.015),{Range = 0}):Play()

	emit.enablevfx(mozsusano,false)
	tween_service:Create(mozsusano.RootPart.a,TweenInfo.new(.15),{Width0 = 0,Width1 = 0}):Play()

	tween_service:Create(mozsusano.RootPart.b,TweenInfo.new(.15),{Width0 = 0,Width1 = 0}):Play()

	for i, v in pairs(mozsusano.bb.beam:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.175,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end


	tween_service:Create(mozsusano.body,TweenInfo.new(.3),{Transparency = 1}):Play()
	tween_service:Create(mozsusano.face,TweenInfo.new(.3),{Transparency = 1}):Play()



	emit.enablevfx(MainBox,false)


	emit.emitvfx(explosionfire1)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
