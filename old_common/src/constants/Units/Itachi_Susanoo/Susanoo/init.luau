local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.45, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .75, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	local sounds = script.Parent.SFXs
	local effectsfolder = workspace.Effects

	

	local mangekyo = script.Move4:FindFirstChild("mangekyo"):Clone()
	mangekyo.CFrame = rt.CFrame * CFrame.new(0,0.8,-0.5)
	mangekyo.Parent = effectsfolder
	debris.AddItem(mangekyo,3)


	local explosionfire1 = script.Move4:FindFirstChild("explosionfire1"):Clone()
	explosionfire1.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	explosionfire1.Parent = effectsfolder
	debris.AddItem(explosionfire1,12.25)

	local explosionfire = script.Move4:FindFirstChild("explosionfire"):Clone()
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


	task.wait(0.015)

	emit.emitvfx(explosionfire)
	SoundWrapper:PlaySound(sounds["fire-ignite4"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(0.015)

	local mozsusano = script.Move4:FindFirstChild("mozsusano"):Clone()
	mozsusano.RootPart.CFrame = rt.CFrame * CFrame.new(0,-2,0)
	mozsusano.Parent = effectsfolder
	debris.AddItem(mozsusano,7.25)

	local MainBox = script.Move4:FindFirstChild("MainBox"):Clone()
	MainBox.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	MainBox.Parent = effectsfolder
	debris.AddItem(MainBox,5)
	emit.enablevfx(MainBox,true)
	local animation = mozsusano.AnimationController:LoadAnimation(AnimModule.GetAnim(script.Susano3slashs)):Play(0.1,1,1.25)


	emit.enablevfx(mozsusano,true)

	for i, v in pairs(mozsusano.bb.beam:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.3,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 3,Width1 = 0.5}):Play()
		end
	end

	tween_service:Create(mozsusano.RootPart.PointLight,TweenInfo.new(.015),{Range = 12}):Play()
	tween_service:Create(mozsusano.body,TweenInfo.new(.1),{Transparency = .4}):Play()
	tween_service:Create(mozsusano.face,TweenInfo.new(.1),{Transparency = 0}):Play()

	tween_service:Create(mozsusano.RootPart.a,TweenInfo.new(.15),{Width0 = 66,Width1 = 15}):Play()

	tween_service:Create(mozsusano.RootPart.b,TweenInfo.new(.15),{Width0 = 15,Width1 = 8}):Play()

	local ExplosionImpact1 = script.Move4:FindFirstChild("ExplosionImpact1"):Clone()
	ExplosionImpact1.CFrame = rt.CFrame * CFrame.new(0,-0.85,0)
	ExplosionImpact1.Parent = effectsfolder
	debris.AddItem(ExplosionImpact1,6.5)

	local ExplosionImpact2 = script.Move4:FindFirstChild("ExplosionImpact2"):Clone()
	ExplosionImpact2.CFrame = rt.CFrame * CFrame.new(0,-0.85,-10)
	ExplosionImpact2.Parent = effectsfolder
	debris.AddItem(ExplosionImpact2,6.5)

	local slash = script.Move4:FindFirstChild("slash"):Clone()
	slash.CFrame = rt.CFrame * CFrame.new(0,1,-6)
	slash.Parent = effectsfolder
	debris.AddItem(slash,3.5)

	local slash1 = script.Move4:FindFirstChild("slash1"):Clone()
	slash1.CFrame = rt.CFrame * CFrame.new(0,1,-6)
	slash1.Parent = effectsfolder
	debris.AddItem(slash1,4.5)

	local slash2 = script.Move4:FindFirstChild("slash2"):Clone()
	slash2.CFrame = rt.CFrame * CFrame.new(0,1,-6)
	slash2.Parent = effectsfolder
	debris.AddItem(slash2,4.5)


	SoundWrapper:PlaySound(sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)

	wait(0.5)

	emit.emitvfx(ExplosionImpact1)
	emit.emitvfx(ExplosionImpact2)

	SoundWrapper:PlaySound(sounds["yamato swing"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(slash)

	wait(.75)

	emit.emitvfx(ExplosionImpact1)
	emit.emitvfx(ExplosionImpact2)

	SoundWrapper:PlaySound(sounds["yamato swing"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(slash1)

	wait(.75)

	emit.emitvfx(ExplosionImpact1)
	emit.emitvfx(ExplosionImpact2)

	SoundWrapper:PlaySound(sounds["yamato swing"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(slash2)

	wait(0.75)

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


	wait(0.2)

	emit.enablevfx(MainBox,false)


	tween_service:Create(mozsusano.body,TweenInfo.new(.3),{Transparency = 1}):Play()
	tween_service:Create(mozsusano.face,TweenInfo.new(.3),{Transparency = 1}):Play()

	emit.emitvfx(explosionfire1)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
