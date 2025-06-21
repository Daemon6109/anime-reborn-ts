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
	HitDelay = 1.8, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})


	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)


	wait(.4)

	--Sound(sounds:FindFirstChild("1"),rt, 4)	



	local PointA = rt.CFrame 
	local PointB = rt.CFrame + (rt.CFrame.LookVector * 7 + Vector3.new(0,5,0))
	local PointC = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + Vector3.new(0,-.5,0)

	task.spawn(function()
		for i=0,1,.05 do
			rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
			local Part = rt
			Part.CFrame = CFrame.new(Bezier(i,PointA.Position,PointB.Position,PointC.Position))
			wait(0.00001)
		end		


		local waterfall = script.waterfall:Clone() -- vfx
		waterfall.Parent = workspace.Effects
		waterfall.Position =  rt.Position + (rt.CFrame.LookVector * 2 + Vector3.new(0,-1,0))
		emit.emitvfx(waterfall)
		emit.enablevfx(waterfall.beams,true)

		for i, v in pairs(waterfall:GetDescendants()) do -- tween for making the beams appear smooth
			task.spawn(function()
				if v:IsA("Beam") then
					local oldbeamsize = v.Width0
					local oldbeamsize2 = v.Width1
					v.Width0 = 0
					v.Width1 = 0

					local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
					TweenComplete:Play()
					local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})  -- tween for the beams to dissapear
					TweenComplete:Play()

					wait(.3)

					local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = 0})
					TweenComplete:Play()
					local TweenComplete = tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = 0})  -- tween for the beams to dissapear
					TweenComplete:Play()
				end
			end)
		end	
		task.wait(1)
		emit.enablevfx(waterfall.beams,false)
		debris.AddItem(waterfall,1)
	end)




	wait(2)


	unit.Torso.tp:Emit(25) -- teleporting the unit back
	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	unit.Torso.tp:Emit(25)		
	wait(.8)


	wait(1)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
