local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.5, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .55, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["ATk3"], rt, Replicated.SoundGroups.UnitSFX)


	local tp = script:FindFirstChild("tp"):Clone()
	tp.CFrame = rt.CFrame * CFrame.new(0,0,1)
	tp.Parent = workspace.Effects
	debris.AddItem(tp,5)

	local dash = script:FindFirstChild("dash"):Clone()
	dash.CFrame = rt.CFrame * CFrame.new(0,0,1.5)
	dash.Parent = workspace.Effects
	dash.CFrame = CFrame.new(dash.Position, pos.Position)
	debris.AddItem(dash,5)

	local a = script:FindFirstChild("a"):Clone()
	a.CFrame = rt.CFrame * CFrame.new(0,0,1)
	a.Parent = workspace.Effects
	a.CFrame = CFrame.new(dash.Position, pos.Position)
	debris.AddItem(a,5)

	local b = script:FindFirstChild("b"):Clone()
	b.Parent = workspace.Effects
	b.CFrame = CFrame.new(dash.Position, pos.Position)
	debris.AddItem(b,5)

	local dash = script:FindFirstChild("dash"):Clone()
	dash.CFrame = rt.CFrame * CFrame.new(0,0,1.5)
	dash.Parent = workspace.Effects
	dash.CFrame = CFrame.new(dash.Position, pos.Position)
	debris.AddItem(dash,5)

	local dispair = script:FindFirstChild("dispair"):Clone()
	dispair.Parent = workspace.Effects
	debris.AddItem(dispair,5)

	local fr = script:FindFirstChild("fire"):Clone()
	fr.Parent = workspace.Effects
	debris.AddItem(fr,5)


	wait(0.3)


	emit.enablevfx(unit.Torso.a,true)
	emit.enablevfx(unit.Torso.b,true)

	wait(0.3)

	emit.emitvfx(dash)

	emit.emitvfx(a)


	local shoottween = tween_service:Create(rt, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = pos.CFrame}):Play()

	wait(0.3)

	b.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	emit.emitvfx(b)


	wait(0.7)



	emit.enablevfx(unit.Torso.a,false)

	emit.enablevfx(unit.Torso.b,false)
	fr.CFrame = rt.CFrame * CFrame.new(0,-1,0)

	emit.emitvfx(fr)

	dispair.CFrame = rt.CFrame * CFrame.new(0,.5,-1)

	local shoottween = tween_service:Create(dispair.PointLight, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Range = 16}):Play()

	emit.emitvfx(dispair)

	wait(0.3)

	local shoottween = tween_service:Create(dispair.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Range = 0}):Play()

	wait(0.3)
	local back = unit.back


	emit.emitvfx(tp)
	rt.CFrame = back.CFrame

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
