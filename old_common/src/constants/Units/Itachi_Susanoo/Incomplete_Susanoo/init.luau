local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 2.7, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .85, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	
	local sounds = script.Parent.SFXs
	local effectsfolder = workspace.Effects

	SoundWrapper:PlaySound(sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)


	local mangekyo = script.Move4:FindFirstChild("mangekyo"):Clone()
	mangekyo.CFrame = rt.CFrame * CFrame.new(0,0.8,-0.5)
	mangekyo.Parent = effectsfolder
	debris.AddItem(mangekyo,3)

	local explosionfire1 = script.Move3:FindFirstChild("explosionfire1"):Clone()
	explosionfire1.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	explosionfire1.Parent = effectsfolder
	debris.AddItem(explosionfire1,8.25)

	local explosionfire = script.Move3:FindFirstChild("explosionfire"):Clone()
	explosionfire.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	explosionfire.Parent = effectsfolder
	debris.AddItem(explosionfire,8.35)

	local impact = script.Move3:FindFirstChild("impact"):Clone()
	impact.CFrame = rt.CFrame * CFrame.new(0,-1,-5)
	impact.Parent = effectsfolder
	debris.AddItem(impact,6.35)

	local susano = script.Move3:FindFirstChild("Itachi Susanoo"):Clone()
	susano.RootPart.CFrame = rt.CFrame * CFrame.new(0,-1.75,0)

	debris.AddItem(susano,8.35)

	local highlight = Instance.new("Highlight")
	highlight.Parent = susano
	highlight.FillColor = Color3.fromRGB(255, 69, 69)
	highlight.FillTransparency = 0.8
	highlight.OutlineColor = Color3.fromRGB(255, 94, 94)
	highlight.OutlineTransparency = 0.8
	highlight.Enabled = true

	task.wait(0.5)

--	SoundWrapper:PlaySound(sounds["Sharingan Activate (NOT MONGEKYO)"], rt, Replicated.SoundGroups.UnitSFX)

	wait(0.15)

	emit.emitvfx(mangekyo)

	task.wait(0.1)

	SoundWrapper:PlaySound(sounds["Flame2ndSkill"], rt, Replicated.SoundGroups.UnitSFX)

	susano.Parent = effectsfolder

	emit.emitvfx(explosionfire1)


	local animation = susano.AnimationController:LoadAnimation(AnimModule.GetAnim(script.SusanoIncomplete)):Play()

	emit.emitvfx(susano,true)

	tween_service:Create(susano.torso,TweenInfo.new(.15),{Transparency = 0}):Play()

	tween_service:Create(susano.eye,TweenInfo.new(.15),{Transparency = 0}):Play()

	SoundWrapper:PlaySound(sounds["sword fire slash"], rt, Replicated.SoundGroups.UnitSFX)
	tween_service:Create(susano.RootPart.PointLight,TweenInfo.new(.2),{Range = 16}):Play()
	task.wait(0.1)

	emit.emitvfx(explosionfire1)

	task.wait(1.35)

	local hand = script.Move3:FindFirstChild("hand"):Clone()
	hand.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	hand.Parent = effectsfolder
	debris.AddItem(hand,5.5)

	SoundWrapper:PlaySound(sounds["Dragon-Ball-Z-Punch-Sound-Effect-N°9"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(0.1)

	emit.emitvfx(hand)

	SoundWrapper:PlaySound(sounds["magic-cast-heavy03"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(0.6)

	SoundWrapper:PlaySound(sounds["Dragon-Ball-Z-Punch-Sound-Effect-N°9"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(0.1)

	SoundWrapper:PlaySound(sounds["magic-cast-heavy03"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(0.85)

	SoundWrapper:PlaySound(sounds["magic-cast-heavy04"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(impact)



	task.wait(1)


	tween_service:Create(susano.RootPart.PointLight,TweenInfo.new(.35),{Range = 0}):Play()

	SoundWrapper:PlaySound(sounds["bless09"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(explosionfire1)

	emit.enablevfx(susano,false)

	tween_service:Create(susano.torso,TweenInfo.new(.35),{Transparency = 1}):Play()

	tween_service:Create(susano.eye,TweenInfo.new(.35),{Transparency = 1}):Play()
	
	task.wait(.35)
	highlight:Destroy()

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
