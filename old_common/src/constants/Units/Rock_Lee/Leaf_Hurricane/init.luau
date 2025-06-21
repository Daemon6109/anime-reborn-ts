local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .275, -- delay between hits in a multi-hit move
	EndingDelay = .45

}

local effectsfolder = workspace.Effects

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	local back = unit.back
	back.CFrame = CFrame.lookAt(rt.Position, Vector3.new(pos.Position.X, rt.Position.Y, pos.Position.Z))

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Atk2"], rt, Replicated.SoundGroups.UnitSFX)


	tween_service:Create(rt, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = back.CFrame * CFrame.new(0,0,-2)}):Play()
	task.spawn(function()
		local impact = script:FindFirstChild("dash2"):Clone()
		impact.CFrame = back.CFrame * CFrame.new(0,0,-0)
		impact.Parent = effectsfolder
		debris.AddItem(impact,3.5)
		emit.emitvfx(impact)

	end)

	wait(0.3)
	task.spawn(function()
		local impact = script:FindFirstChild("impact"):Clone()
		impact.CFrame = back.CFrame * CFrame.new(0,-1,-2)
		impact.Parent = effectsfolder
		debris.AddItem(impact,3.5)
		emit.emitvfx(impact)
	end)

	task.spawn(function()
		local impact = script:FindFirstChild("dash2"):Clone()
		impact.CFrame = back.CFrame * CFrame.new(0,0,-2)
		impact.Parent = effectsfolder
		debris.AddItem(impact,3.5)
		emit.emitvfx(impact)
	end)

	tween_service:Create(rt, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = back.CFrame * CFrame.new(0,0,-4)}):Play()
	wait(.3)
	task.spawn(function()
		local impact = script:FindFirstChild("impact"):Clone()
		impact.CFrame = back.CFrame * CFrame.new(0,-1,-4)
		impact.Parent = effectsfolder
		debris.AddItem(impact,3.5)
		emit.emitvfx(impact)
	end)


	task.spawn(function()
		local impact = script:FindFirstChild("dash2"):Clone()
		impact.CFrame = back.CFrame * CFrame.new(0,0,-4)
		impact.Parent = effectsfolder
		debris.AddItem(impact,3.5)
		emit.emitvfx(impact)
	end)


	tween_service:Create(rt, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = back.CFrame * CFrame.new(0,0,-6)}):Play()	
	wait(.3)
	task.spawn(function()
		local impact = script:FindFirstChild("impact"):Clone()
		impact.CFrame = back.CFrame * CFrame.new(0,-1,-6)
		impact.Parent = effectsfolder
		debris.AddItem(impact,3.5)
		emit.emitvfx(impact)

	end)
	wait(.3)


	tween_service:Create(rt, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = back.CFrame * CFrame.new(0,0,-8)}):Play()	
	wait(.4)
	task.spawn(function()
		local impact = script:FindFirstChild("dash2"):Clone()
		impact.CFrame = back.CFrame * CFrame.new(0,-1,-6)
		impact.Parent = effectsfolder
		debris.AddItem(impact,3.5)
		emit.emitvfx(impact)
	end)

	task.spawn(function()

		local impact = script:FindFirstChild("impact1"):Clone()
		impact.CFrame = back.CFrame * CFrame.new(0,-1,-8)
		impact.Parent = effectsfolder
		debris.AddItem(impact,3.5)
		emit.emitvfx(impact)
	end)

	wait(1)
	rt.CFrame = back.CFrame
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
