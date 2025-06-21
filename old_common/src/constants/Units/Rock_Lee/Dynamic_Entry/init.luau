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
	MultihitDelay = .85, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	local back = unit.back
	back.CFrame = CFrame.new(back.Position, pos.Position)

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector

	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})

	local move2 = script:FindFirstChild("move2"):Clone()
	move2.part.CFrame = pos.CFrame * CFrame.new(0,-0.8,0)
	move2.Parent = effectsfolder
	debris.AddItem(move2,4.5)

	local dash3 = script:FindFirstChild("dash3"):Clone()
	dash3.CFrame = rt.CFrame
	dash3.Parent = effectsfolder
	debris.AddItem(dash3,3)
	wait(0.1)
	
	emit.emitvfx(dash3)
	tween_service:Create(rt, TweenInfo.new(.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)}):Play()
	
	local atk2 = script:FindFirstChild("atk2"):Clone()
	atk2.part.CFrame = pos.CFrame * CFrame.new(0,0,0)
	atk2.Parent = effectsfolder
	debris.AddItem(atk2,4)
	
	local dashtop = script:FindFirstChild("dashtop"):Clone()
	dashtop.CFrame = pos.CFrame * CFrame.new(0,-0.8,0)
	dashtop.Parent = effectsfolder
	debris.AddItem(dashtop,5.5)
	wait(0.5)

	emit.emitvfx(atk2)
	wait(0.55)

	emit.emitvfx(dashtop)
	wait(0.2)
	tween_service:Create(rt, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = rt.CFrame * CFrame.new(0,6,0)}):Play()
	wait(0.35)
	tween_service:Create(rt, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = rt.CFrame * CFrame.new(0,-6,0)}):Play()
	wait(0.1)
	emit.emitvfx(move2)

	wait(.15)



	wait(0.75)
	local tp1 = script:FindFirstChild("tpskill"):Clone()
	tp1.Parent = effectsfolder
	debris.AddItem(tp1,3)
	emit.emitvfx(tp1)
	tp1.HumanoidRootPart.CFrame = back.CFrame
	
	rt.CFrame = back.CFrame

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
