local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 2.285, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	--print(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local back = unit.back
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	back.CFrame = CFrame.new(back.Position, pos.Position)
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation5, unit, 1, "", {Weight = 2, Fade = .15})
	
	
	local grdash1 = script.Move4:FindFirstChild("grdash1"):Clone()
	grdash1.CFrame = rt.CFrame * CFrame.new(0,-1.9,0)
	grdash1.Parent = workspace.Effects
	debris.AddItem(grdash1,6.5)


	local MainBox1 = script.Move4:FindFirstChild("MainBox1"):Clone()
	MainBox1.CFrame = rt.CFrame * CFrame.new(0,-1.9,0)
	MainBox1.Parent = workspace.Effects
	debris.AddItem(MainBox1,6.5)

	local blueflame = script.Move4:FindFirstChild("blueflame"):Clone()
	blueflame.CFrame = rt.CFrame * CFrame.new(0,-1.9,0)
	blueflame.Parent = workspace.Effects
	debris.AddItem(blueflame,5)



	unit.Head.eb.a.Enabled = true
	unit.Head.eb1.a.Enabled = true

	SoundWrapper:PlaySound(script["SfxKaido"], rt, Replicated.SoundGroups.UnitSFX)
	wait(0.2)


	emit.emitvfx(grdash1)
	

	wait(0.2)

	emit.enablevfx(blueflame,true)


	local ExplosionImpact12 = script.Move4:FindFirstChild("ExplosionImpact12"):Clone()
	ExplosionImpact12.Parent = workspace.Effects
	debris.AddItem(ExplosionImpact12,4)

	emit.enablevfx(unit["Right Arm"],true)

	emit.emitvfx(unit["Right Arm"].MainBox1.emit)


	emit.enablevfx(MainBox1,true)

	wait(0.6)
	emit.enablevfx(blueflame,false)

	local shoottween = tween_service:Create(MainBox1, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = pos.CFrame * CFrame.new(0,-1.8,0)}):Play()
	local shoottween = tween_service:Create(rt, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = pos.CFrame}):Play()

	wait(0.4)

	emit.enablevfx(unit["Right Arm"],false)


	emit.enablevfx(unit.emits,true)

	wait(0.4)

	local shoottween = tween_service:Create(ExplosionImpact12.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 20}):Play()

	emit.emitvfx(unit["Right Arm"].MainBox1.emit)

	emit.enablevfx(MainBox1,false)

	unit.Head.eb.a.Enabled = false
	unit.Head.eb1.a.Enabled = false

	ExplosionImpact12.CFrame = rt.CFrame * CFrame.new(0,-1.9,-3)
	emit.emitvfx(ExplosionImpact12)
	emit.enablevfx(unit.emits,false )


	SoundWrapper:PlaySound(script["magic-cast-heavy14"], rt, Replicated.SoundGroups.UnitSFX)

	wait(0.4)

	local shoottween = tween_service:Create(ExplosionImpact12.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 0}):Play()

	wait(.6)



	rt.CFrame = back.CFrame

	emit.emitvfx(grdash1)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
