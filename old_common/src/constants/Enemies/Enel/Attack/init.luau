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
	HitDelay = 1.25, -- seconds
	Duration = .25,
	TurnTime = .7,
	StunTime = 5,
	AttackRange = 35,
	AttackSize = 15,
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})

	--SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)


	task.wait(.2)

	local charge = script.EnelCharge:Clone()  
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-1,0)
	emit.enablevfx(charge,true)
	charge.Anchored = true	
		
	task.spawn(function()
		for i=0,10,1 do
			emit.bezier(charge.CFrame,ColorSequence.new(Color3.fromRGB(38, 125, 255)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			task.wait(.1)
		end
	end)
	
	task.wait(.2)
	
	local bolt = script.thunderboltimpact:Clone()  
	bolt.Parent = workspace.Effects
	bolt.Position = pos.Position + Vector3.new(0,-1,0)
	bolt.Anchored = true
	
	local smoke = script.thunderbolsmoke:Clone()  
	smoke.Parent = workspace.Effects
	smoke.Position = bolt.down.WorldPosition
	emit.enablevfx(smoke,true)
	smoke.Anchored = true
	
	
	task.wait(0.8)
	emit.enablevfx(charge,false)

	
	task.wait(.2)
	task.spawn(function()
		task.wait(.15)
		local meshvf = script.WindMesh:Clone() -- vfx
		meshvf.Parent = workspace.Effects
		meshvf.Position = pos.Position + Vector3.new(0,2,0)
		spr.target(meshvf.Mesh, 1.2, 9.4, {Scale = Vector3.new(0.25, 0.7, 0.8)})
		spr.target(meshvf, 1.5, 9, {Position = meshvf.Position + Vector3.new(0,-33,0)})
		task.wait(.14)
		meshvf:Destroy()
	end)
	task.spawn(function()
		task.wait(.2)
		local meshvf2 = script.WindMesh3:Clone() -- vfx
		meshvf2.Parent = workspace.Effects
		meshvf2.Position = pos.Position + Vector3.new(0,1,0)

		spr.target(meshvf2, 1.3, 2.3, {Size = Vector3.new(25.955, .99, 25.955)})
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In,1),{Orientation = meshvf2.Orientation + Vector3.new(0,66,0)})
		TweenComplete:Play()
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()

		task.wait(.5)
		meshvf2:Destroy()
	end)
	task.spawn(function()
		task.wait(.13)
		local meshvf2 = script.MeshPartShockwave:Clone() -- vfx
		meshvf2.Parent = workspace.Effects
		meshvf2.Position = pos.Position + Vector3.new(0,0,0)

		spr.target(meshvf2, 1.3, 5.3, {Size = Vector3.new(33.655, 5.127, 33.327)})

		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.55,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()

		task.wait(.55)
		meshvf2:Destroy()
	end)

	emit.emitvfx(bolt)
	task.wait(.1)
	rocksmodule.Ground(pos.Position + Vector3.new(0,3.5,0),18, Vector3.new(1.6, 1.6, 1.6), nil, 15, false, .8) -- ground crack module

	emit.enablevfx(smoke,false)

	task.wait(1)


	debris.AddItem(bolt,1)
	debris.AddItem(charge,1)

	debris.AddItem(smoke,1)


	task.wait(2)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
