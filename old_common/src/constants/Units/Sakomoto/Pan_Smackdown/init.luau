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
	HitDelay = 1.7, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end


local function EmitParticles(part)
	for i,v in part:GetDescendants() do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v:Emit(v:GetAttribute("EmitCount"))
				end 

				local _delay = v:GetAttribute("EmitDuration")
				if _delay then
					v.Enabled = true
					task.delay(_delay, function()
						v.Enabled = false
					end)
				end
			end)()
		end
	end
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.2, "", {Weight = 2, Fade = .15})

	task.spawn(function()
		task.wait(.3)
		SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

	end)	
	task.wait(.2)
	
	emit.emitvfx(unit.Torso.jump)
	emit.emitvfx(unit.Pan)
	unit.Pan.Transparency = 0
	
	task.wait(.4)
	
	local newpan = unit.Pan:Clone()
	newpan.Parent = effectsfolder
	debris.AddItem(newpan,5)
	unit.Pan.Transparency = 1

	local TweenComplete = tween_service:Create(newpan,TweenInfo.new(.35,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Orientation = newpan.Orientation + Vector3.new(11,180,11)})
	TweenComplete:Play()
	local TweenCompletepo = tween_service:Create(newpan,TweenInfo.new(.35,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -1) + Vector3.new(0,6,0)})
	TweenCompletepo:Play()
	newpan.Anchored = true
	
	task.wait(.35)
			
	local TP = script.Tpsakomoto:Clone() 
	TP.Parent = workspace.Effects
	TP.CFrame = rt.CFrame
	EmitParticles(TP)
	debris.AddItem(TP,3)
	
	task.wait(.02)
	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -1.2) + Vector3.new(0,6,0) + (rt.CFrame.RightVector * -.5)
	
	newpan.Transparency = 1
	unit.Pan.Transparency = 0


	task.wait(0.01)
	local TP2 = script.Tpsakomoto:Clone() 
	TP2.Parent = workspace.Effects
	TP2.CFrame = rt.CFrame
	EmitParticles(TP2)
	debris.AddItem(TP2,3)

	task.wait(.4)
	
	local Top = script["Sakomotoatk2 Top"]:Clone() 
	Top.Parent = workspace.Effects
	Top.Position = rt.Position + Vector3.new(0,.5,0)
	emit.emitvfx(Top)
	debris.AddItem(Top,3)
	
	local TweenCompletepo = tween_service:Create(rt,TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = rt.CFrame + Vector3.new(0,-6.5,0)})
	TweenCompletepo:Play()
	
	task.spawn(function() -- mesh vxf
		task.wait(.085)
		local downmesh = script.Wind2:Clone() -- vfx
		downmesh.Parent = effectsfolder
		downmesh.Position = pos.Position + Vector3.new(0,2,0)

		spr.target(downmesh.Mesh, 1.3, 2.3, {Scale = Vector3.new(9.918, 10.984, 9.248)})
		spr.target(downmesh, 1.3, 2.3, {Position = downmesh.Position + Vector3.new(0,-4.5,0)})

		local TweenComplete = tween_service:Create(downmesh,TweenInfo.new(.4,Enum.EasingStyle.Sine,Enum.EasingDirection.In,1),{Orientation = downmesh.Orientation + Vector3.new(0,444,0)})
		TweenComplete:Play()
		local TweenComplete = tween_service:Create(downmesh.Decal,TweenInfo.new(.4,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()
	end)
	rocksmodule.Ground(pos.Position + Vector3.new(0,1.5,0),15, Vector3.new(1.15, 1.15, 1.15), nil, 21, false, .45) -- ground crack module

	task.wait(.15)	


	local bottom = script["Sakomotoatk2 Bottom"]:Clone() 
	bottom.Parent = workspace.Effects
	bottom.Position = rt.Position + Vector3.new(0,-1,0)
	emit.emitvfx(bottom)
	debris.AddItem(bottom,3)
	
	task.spawn(function() -- mesh vxf
		local meshvf2 = script.WindMesh3:Clone() -- vfx
		meshvf2.Parent = effectsfolder
		meshvf2.Position = pos.Position + Vector3.new(0,-1,0)

		spr.target(meshvf2, 1.3, 1.3, {Size = Vector3.new(22.955, .8, 22.955)})
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In,1),{Orientation = meshvf2.Orientation + Vector3.new(0,88,0)})
		TweenComplete:Play()
		local TweenComplete = tween_service:Create(meshvf2,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()
	end)

	task.wait(.7)

	local TP = script.Tpsakomoto:Clone() 
	TP.Parent = workspace.Effects
	TP.CFrame = rt.CFrame
	EmitParticles(TP)
	debris.AddItem(TP,3)

	task.wait(.05)
	rt.CFrame = startpos

	newpan.Transparency = 1
	emit.emitvfx(unit.Pan)
	unit.Pan.Transparency = 1

	task.wait(0.1)
	local TP2 = script.Tpsakomoto:Clone() 
	TP2.Parent = workspace.Effects
	TP2.CFrame = rt.CFrame
	EmitParticles(TP2)
	debris.AddItem(TP2,3)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
