local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .7, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})

	local SavedDirection = rt.CFrame.LookVector
	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)

	local enable = script.atk2enable:Clone() -- vfx
	enable.Parent = workspace.Effects
	enable.Position = rt.Position + Vector3.new(0,-1.25,0)
	emit.enablevfx(enable,true)
	debris.AddItem(enable,3)
	emit.trailonoff(unit.Folder,true)

	local endposss = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * 7)  -- THIS MOVE IS SUPPOSED TO BE LINE/CONE AOE SO THE END POSITION ISN'T THE ENEMY POS
	task.spawn(function()
		for i=0,5,1 do
			wait(.1)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(26, 255, 45)),0.0005,.7,"Long",false,0,0,4)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.0005,.7,"Long",false,0,0,4)
		end
	end)
	wait(.55)


	emit.emitvfx(enable.emit)
	emit.enablevfx(enable,false)

	local slash = script.atk2slash:Clone() -- vfx
	slash.Parent = workspace.Effects
	slash.CFrame =  rt.CFrame + (rt.CFrame.LookVector * 1) 
	slash.a.CFrame =  rt.CFrame + (rt.CFrame.LookVector * 0) 
	emit.enablevfx(slash,true)
	emit.enablevfx(slash.a,true)
	debris.AddItem(slash,3)

	emit.emitvfx(slash.Attachment2)

	for i, v in pairs(slash:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1

				v.Width0 = 0
				v.Width1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})  -- tween for the beams to dissapear
				TweenComplete:Play()


				wait(.25)

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = 0})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = 0})  -- tween for the beams to dissapear
				TweenComplete:Play()


			end
		end)
	end	

	local info = TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	local tween = tween_service:Create(slash,info,{CFrame = endposss}) -- tween for the slash
	tween:Play()
	local info = TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	local tween = tween_service:Create(slash.a,info,{CFrame = endposss}) -- tween for the slash
	tween:Play()

	local trailpartup = script.Gotrail:Clone()
	trailpartup.Parent = workspace.Effects
	trailpartup.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	task.spawn(function()

		local info = TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
		local tween = tween_service:Create(trailpartup,info,{CFrame = endposss})
		tween:Play()
		local info = TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0)
		local tween = tween_service:Create(trailpartup,info,{Orientation = trailpartup.Orientation + Vector3.new(0,180,0)})
		tween:Play()
		task.wait(.4 + .6)
		trailpartup:Destroy()
	end)


	wait(.3)

	emit.enablevfx(slash.Attachment2,false)
	emit.enablevfx(slash.trail1,false)
	emit.enablevfx(slash.sidesmokeee,false)
	emit.enablevfx(slash.sidesmokee,false)
	emit.enablevfx(slash.effect,false)
	emit.enablevfx(slash.a,false)


	emit.trailonoff(unit.Folder,false)


	emit.emitvfx(slash.emit)


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
