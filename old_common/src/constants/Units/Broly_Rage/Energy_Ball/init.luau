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
	HitDelay = 1.5, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .5, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})




	local orb = script.energyball:Clone() -- vfx
	orb.Parent = workspace.Effects
	orb.PrimaryPart.Position = unit["Right Arm"].pos.WorldPosition
	emit.enablevfx(orb,true)
	orb["energyball(atk2)"].Energyblal.Parent = unit["Right Arm"].pos
	debris.AddItem(orb,3)


	SoundWrapper:PlaySound(script["2"], orb, Replicated.SoundGroups.UnitSFX)
	task.wait(.35)


	orb.PrimaryPart.Position = unit["Right Arm"].pos.WorldPosition
	unit["Right Arm"].pos.Energyblal.Parent = orb.PrimaryPart

	local trailpartup = script.OrbFrontTrail:Clone()
	trailpartup.Parent = workspace.Effects
	trailpartup.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	task.spawn(function()

		local info = TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
		local tween = tween_service:Create(trailpartup,info,{Orientation = trailpartup.Orientation + Vector3.new(0,0,360)})
		tween:Play()
		local info = TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In)
		local tween = tween_service:Create(trailpartup,info,{Position = pos.Position}) -- tween for the beam to move to the position
		tween:Play()
		task.wait(1.2)
		trailpartup:Destroy()
	end)

	local info = TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In)
	local tween = tween_service:Create(orb.PrimaryPart,info,{Position = pos.Position}) -- tween for the orb
	tween:Play()

	task.spawn(function() -- bezier curve with a trail
		for i=0,5,1 do
			task.wait(.1)
			emit.bezier(orb.PrimaryPart.CFrame,ColorSequence.new(Color3.fromRGB(67, 255, 34)),0.00000000005,1,"Mid",true,0.5,3)
			emit.bezier(orb.PrimaryPart.CFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.00000000005)
		end
	end)

	task.wait(.2)

	local oldscale = orb:GetScale()

	task.spawn(function()
		for i=0,3,1 do
			orb:ScaleTo(oldscale + .7)
			oldscale = orb:GetScale()
			emit.emitvfx(orb["energyball(atk2)"].Emitwhenmakebigger)
			task.wait(.2)
		end
	end)	

	task.wait(.5)

	emit.emitvfx(orb["energyball(atk2)"].Emitwhenmakebigger)

	emit.enablevfx(orb,false)

	local ballish = script.quick360orbbroly:Clone() -- vfx
	ballish.Parent = workspace.Effects
	ballish.PrimaryPart.Position = pos.Position
	emit.enablevfx(ballish,true)
	emit.emitvfx(ballish)





	debris.AddItem(ballish,3)



	local quickemit = script.Smoke:Clone() -- vfx for when the ball arrives at the pos
	quickemit.Parent = workspace.Effects
	quickemit.Position = pos.Position 
	emit.emitvfx(quickemit)
	emit.enablevfx(quickemit,true) 
	debris.AddItem(quickemit,3)



	task.spawn(function() -- bezier curve with a trail
		for i=0,6,1 do
			task.wait(.045)
			emit.bezier(ballish.PrimaryPart.CFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.00000000005,.3,"Mid",true,5,.5,3)
			emit.bezier(ballish.PrimaryPart.CFrame,ColorSequence.new(Color3.fromRGB(48, 255, 48)),0.00000000005,.3,"Mid",true,5,.5,3)
		end
	end)


	for i=0,15,1 do -- for resizing the orb explosion
		ballish:SetPrimaryPartCFrame(pos.CFrame + Vector3.new(0,-1,0))
		local a = math.random(400,3000)/1000
		ballish:ScaleTo(a)
		wait(.03)
	end

	emit.enablevfx(ballish,false)
	emit.emitvfx(quickemit)
	emit.enablevfx(quickemit,false)
	ballish:Destroy()
	local exp = script.Atk2impact:Clone() -- vfx
	exp.Parent = workspace.Effects
	exp.Position = pos.Position
	emit.emitvfx(exp)
	debris.AddItem(exp,2)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
