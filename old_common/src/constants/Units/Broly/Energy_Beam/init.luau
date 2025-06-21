local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

module.config = {
	HitDelay = 1, -- seconds
	HitCount = 7, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector

	local newanim =	AnimModule.PlayAnim(script.thirdattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["3"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.1)

	local beam = script["Energy Beam(atk3)"]:Clone() -- vfx
	beam.Parent = workspace.Effects
	beam.CFrame =  rt.CFrame + (rt.CFrame.LookVector * 1.5 + Vector3.new(0,1,0))
	debris.AddItem(beam,3)

	emit.enablevfx(beam.Particles.Attachment,true)

	task.spawn(function() -- bezier curve with a trail
		for i=0,3,1 do
			emit.bezier(beam.Particles.Attachment.WorldCFrame,ColorSequence.new(Color3.fromRGB(67, 255, 34)),0.00000000005,1,"Mid",true,0.5,3,1.4)
			emit.bezier(beam.Particles.Attachment.WorldCFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.00000000005,1,"Mid",true,0,0,1.4)
			task.wait(.1)
		end
	end)

	task.wait(.3)

	AnimModule.ChangeAnimSpeed(newanim,1.4)

	emit.enablevfx(beam,true)

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

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width0 = oldbeamsize * 2.7})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width1 = oldbeamsize2 * 2.7})
				TweenComplete:Play()

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{CurveSize0 = oldcurve * 2.7})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{CurveSize1 = oldcurve2 * 2.7})
				TweenComplete:Play()

				local info = TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
				local tween = tween_service:Create(v.Parent,info,{WorldPosition = (rt.CFrame * CFrame.new(0,0,-15)).Position}) -- tween for the beam to move to the position
				tween:Play()

				task.wait(.15)

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize * 1.2}) -- tween for the beam to not be huge anymore
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2 * 1.2})
				TweenComplete:Play()

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{CurveSize0 = oldcurve * 1.2})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{CurveSize1 = oldcurve2 * 1.2})
				TweenComplete:Play()

				task.wait(.4)

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldcurve2 * .7}) --tween for the beam to go to normal size
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize * .7})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{CurveSize0 = oldcurve * .7}) 
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{CurveSize1 = oldcurve2 * .7})
				TweenComplete:Play()

				task.wait(.4)
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width0 = 0}) --tweens for the beams to dissapear smoothly
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{CurveSize0 = 0}) 
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{CurveSize1 = 0})
				TweenComplete:Play()
			end
		end)
	end		



	task.wait(.1)

	local info = TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	local tween = tween_service:Create(beam:FindFirstChild("end"),info,{WorldPosition = (rt.CFrame * CFrame.new(0,0,-15)).Position}) -- tween for the beam to move to the position
	tween:Play()

	local quickemit = script.SmokeSmalll:Clone() -- smoke vfx
	quickemit.Parent = workspace.Effects
	quickemit.Position = rt.Position + Vector3.new(0,-.5,0) 
	emit.enablevfx(quickemit,true) 
	debris.AddItem(quickemit,3)

	task.wait(.85)

	emit.emitvfx(quickemit)
	emit.emitvfx(unit.Torso.jump)
	emit.enablevfx(quickemit,false)
	emit.emitvfx(beam)

	task.wait(.15)

	emit.enablevfx(beam,false)
	emit.enablevfx(beam.beams,true)



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
