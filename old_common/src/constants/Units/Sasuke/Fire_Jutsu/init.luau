local module = {}


local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .85, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	local SavedDirection = rt.CFrame.LookVector
	
	local newanim=	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)


	wait(.45)
	AnimModule.ChangeAnimSpeed(newanim,.7)

	local beam = script.FireballJutsu:Clone() -- vfx
	beam.Parent = workspace.Effects
	beam.CFrame =  rt.CFrame + (rt.CFrame.LookVector * .4 + Vector3.new(0,.5,0))
	emit.enablevfx(beam,true)
	debris.AddItem(beam,2.5)


	for i, v in pairs(beam.beams:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
				local oldcurve = v.CurveSize0
				local oldcurve2 = v.CurveSize1

				v.Width0 = 0
				v.Width1 = 0
				v.CurveSize0 = 0
				v.CurveSize1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{CurveSize0 = oldcurve})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{CurveSize1 = oldcurve2})
				TweenComplete:Play()

				wait(.8)

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width0 = 0}) --tweens for the beams to dissapear smoothly
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{CurveSize0 = 0}) 
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{CurveSize1 = 0})
				TweenComplete:Play()
			end
		end)
	end		



	task.wait(.8)

	emit.enablevfx(beam,false)
	emit.enablevfx(beam.beams,true)



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
