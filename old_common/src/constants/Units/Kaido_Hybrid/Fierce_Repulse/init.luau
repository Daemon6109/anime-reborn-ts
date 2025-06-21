local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.2, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local back = unit.back
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	back.CFrame = CFrame.new(back.Position, pos.Position)
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	
	
	local grdash1 = script.Move5:FindFirstChild("grdash1"):Clone()
	grdash1.CFrame = rt.CFrame * CFrame.new(0,-1.9,0)
	grdash1.Parent = workspace.Effects
	debris.AddItem(grdash1,6.5)

	local ExplosionImpact1 = script.Move5:FindFirstChild("ExplosionImpact1"):Clone()
	ExplosionImpact1.CFrame = rt.CFrame * CFrame.new(0,4,0)
	ExplosionImpact1.Parent =  workspace.Effects
	debris.AddItem(ExplosionImpact1,3.5)

	local hand = script.Move5:FindFirstChild("hand"):Clone()
	hand.CFrame = rt.CFrame * CFrame.new(0,-1.9,0)
	hand.Parent =  workspace.Effects
	debris.AddItem(hand,4.5)

	local hand1 = script.Move5:FindFirstChild("hand1"):Clone()
	hand1.CFrame = rt.CFrame * CFrame.new(0,4,0)
	hand1.Parent =  workspace.Effects
	debris.AddItem(hand1,5.5)

	local Part = script.Move5:FindFirstChild("Part"):Clone()
	Part.CFrame = rt.CFrame * CFrame.new(0,-1.9,0)
	Part.Parent =  workspace.Effects
	debris.AddItem(Part,6.5)

	SoundWrapper:PlaySound(script["Mv111"], rt, Replicated.SoundGroups.UnitSFX)
	SoundWrapper:PlaySound(script["main"], rt, Replicated.SoundGroups.UnitSFX)
	wait(0.1)

	local shoottween = tween_service:Create(Part.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 16}):Play()

	emit.enablevfx(unit.Humanoid.Model["Kaido Weapon"],true)

	emit.emitvfx(grdash1)

	wait(0.2)

	emit.enablevfx(Part,true)

	wait(0.4)

	emit.enablevfx(unit.Torso.Attachment,true)

	wait(0.25)

	hand1.CFrame = CFrame.new(hand1.Position, pos.Position)
	emit.emitvfx(hand1)

	emit.emitvfx(hand)

	emit.emitvfx(ExplosionImpact1)

	local shoottween = tween_service:Create(Part.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 0}):Play()

	emit.enablevfx(Part,false)

	local shoottween = tween_service:Create(rt, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = pos.CFrame * CFrame.new(0,-1,0)}):Play()




	local ExplosionImpact12 = script.Move5:FindFirstChild("ExplosionImpact12"):Clone()
	ExplosionImpact12.Position = pos.Position+ Vector3.new(0,.1,0)
	ExplosionImpact12.Parent =  workspace.Effects 
	debris.AddItem(ExplosionImpact12,6.5)

	local shoottween = tween_service:Create(ExplosionImpact12.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 22}):Play()

	wait(0.05)
	emit.emitvfx(ExplosionImpact12)

	wait(0.1)

	emit.enablevfx(unit.Humanoid.Model["Kaido Weapon"],false)

	emit.enablevfx(unit.Torso.Attachment,false)

	wait(0.05)


	local shoottween = tween_service:Create(ExplosionImpact12.PointLight, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 0}):Play()

	rt.CFrame = back.CFrame


	wait(1.3)

	emit.emitvfx(grdash1)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
