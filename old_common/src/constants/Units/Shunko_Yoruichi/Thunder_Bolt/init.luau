local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

module.config = {
	HitDelay = 1.55, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)


	task.wait(.2)

	local charge = script.MagicCircle:Clone()  
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + (rt.CFrame.LookVector * 2) 
	emit.emitvfx(charge.Circle)
	
	task.wait(0.8)
	
	emit.emitvfx(charge.Emit)

	emit.emitvfx(unit.Torso.Ready)
	
	task.wait(.2)
	task.spawn(function()
		task.wait(.05)
		local meshvf = script.WindMesh:Clone() -- vfx
		meshvf.Parent = workspace.Effects
		meshvf.Position = pos.Position + Vector3.new(0,2,0)
		spr.target(meshvf.Mesh, 1.2, 3.4, {Scale = Vector3.new(0.25, 0.7, 0.8)})
		spr.target(meshvf, 1.5, 5, {Position = meshvf.Position + Vector3.new(0,-33,0)})
		task.wait(.3)
		meshvf:Destroy()
	end)
	task.spawn(function()
		task.wait(.1)
		local meshvf2 = script.WindMesh3:Clone() -- vfx
		meshvf2.Parent = workspace.Effects
		meshvf2.Position = pos.Position + Vector3.new(0,1,0)

		spr.target(meshvf2, 1.3, 2.3, {Size = Vector3.new(30.955, .99, 30.955)})
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.7,Enum.EasingStyle.Quart,Enum.EasingDirection.In,1),{Orientation = meshvf2.Orientation + Vector3.new(0,66,0)})
		TweenComplete:Play()
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.7,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()

		task.wait(.7)
		meshvf2:Destroy()
	end)
	task.spawn(function()
		task.wait(.13)
		local meshvf2 = script.MeshPartShockwave:Clone() -- vfx
		meshvf2.Parent = workspace.Effects
		meshvf2.Position = pos.Position + Vector3.new(0,0,0)

		spr.target(meshvf2, 1.3, 5.3, {Size = Vector3.new(33.655, 5.127, 33.327)})

		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.6,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()

		task.wait(.6)
		meshvf2:Destroy()
	end)

	local bolt = script.thunderboltimpact:Clone()  
	bolt.Parent = workspace.Effects
	bolt.Position = pos.Position + Vector3.new(0,-1,0)
	emit.emitvfx(bolt)
	rocksmodule.Ground(pos.Position + Vector3.new(0,3.5,0),15, Vector3.new(1, 1, 1), nil, 11, false, 2) -- ground crack module


	task.wait(1)


	debris.AddItem(bolt,1)
	debris.AddItem(charge,1)



	task.wait(2)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
