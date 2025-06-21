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
	HitDelay = 1, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local SavedDirection = rt.CFrame.LookVector

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)

	
	unit.Torso.tp:Emit(15)
	unit.Torso.tp1:Emit(15)
	task.wait(.035)
	rt.CFrame = pos.CFrame + Vector3.new(0,15,0) -- teleporting the unit 
	task.wait(.03)
	unit.Torso.tp:Emit(15)
	unit.Torso.tp1:Emit(15)
	
	emit.enablevfx(unit["Right Leg"],true)

	local up = script.up:Clone()  
	up.Parent = workspace.Effects
	up.Position = pos.Position +Vector3.new(0,-1,0)
	emit.emitvfx(up)
	
	
	task.wait(.4)
	
	local info = TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	local tween = tween_service:Create(rt,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + Vector3.new(0,-1,0)}) -- tween to go to the pos
	tween:Play()

	
	local down = script.tpkickdown:Clone()  
	down.Parent = workspace.Effects
	down.Position = rt.Position
	emit.emitvfx(down)
	
	task.spawn(function()
		local meshvf = script.WindSwirls:Clone() -- vfx
		meshvf.Parent = workspace.Effects
		meshvf.Position = rt.Position + Vector3.new(0,5,0)
		spr.target(meshvf, 1.2, 3, {Size = Vector3.new(3.81, 14.823, 3.504)})
		spr.target(meshvf, 1.5, 3, {Position = pos.Position + Vector3.new(0,-1,0)})
		
		local TweenComplete = tween_service:Create(meshvf,TweenInfo.new(.1,Enum.EasingStyle.Linear,Enum.EasingDirection.In,1),{Orientation = meshvf.Orientation + Vector3.new(0,110,0)})
		TweenComplete:Play()
		task.wait(.2)
		meshvf:Destroy()
	end)
	task.spawn(function()
		task.wait(.2)
		local meshvf2 = script.WindMesh3:Clone() -- vfx
		meshvf2.Parent = workspace.Effects
		meshvf2.Position = pos.Position + Vector3.new(0,0,0)

		spr.target(meshvf2, 1.3, 2.3, {Size = Vector3.new(22.955, .99, 25.955)})
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.6,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Orientation = meshvf2.Orientation + Vector3.new(0,15,0)})
		TweenComplete:Play()
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.6,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()

		task.wait(.6)
		meshvf2:Destroy()
	end)
	task.spawn(function()
		task.wait(.2)
		local meshvf2 = script.Shock:Clone() -- vfx
		meshvf2.Parent = workspace.Effects
		meshvf2.Position = pos.Position + Vector3.new(0,1,0)

		spr.target(meshvf2, 1.3, 2.3, {Size = Vector3.new(21.416, 1.794, 21.653)})
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.6,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Orientation = meshvf2.Orientation + Vector3.new(0,33,0)})
		TweenComplete:Play()
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.6,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()

		task.wait(.6)
		meshvf2:Destroy()
	end)
 	task.wait(.2)
	
	local impact = script.tpkickimpact:Clone()  
	impact.Parent = workspace.Effects
	impact.Position = pos.Position + Vector3.new(0,-1,0)
	emit.emitvfx(impact)
	
	rocksmodule.Ground(pos.Position + Vector3.new(0,2.5,0),13, Vector3.new(1, 1, 1), nil, 11, false, 2) -- ground crack module

	
	emit.enablevfx(unit["Right Leg"],false)

	task.wait(.2)

	unit.Torso.tp:Emit(15)
	unit.Torso.tp1:Emit(7)
	task.wait(.12)
	rt.CFrame = startpos
	task.wait(.03)
	unit.Torso.tp:Emit(15)
	unit.Torso.tp1:Emit(7)

	task.wait(1)
		
	debris.AddItem(up,1)
	debris.AddItem(down,1)
	debris.AddItem(impact,1)


	task.wait(1.5)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
