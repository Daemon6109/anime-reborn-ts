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
	HitDelay = 2.3, -- seconds
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

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	

	task.spawn(function()
		for i=0,5,1 do
			task.wait(.1)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 58, 196)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(84, 41, 255)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(48, 255, 37)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 55, 58)),0.00000000005,.5,"Mid",true,5,.5,1.6)
		end
	end)	

	task.wait(.7)

	local jump = script.Atk2jump:Clone() 
	jump.Parent = workspace.Effects
	jump.Position = rt.Position + Vector3.new(0,-1.2,0)
	emit.emitvfx(jump)
	debris.AddItem(jump,3)
	
	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.85,Enum.EasingStyle.Quart,Enum.EasingDirection.Out,0),{CFrame =rt.CFrame + Vector3.new(0,15,0)})
	TweenComplete:Play()
	
	
	
	task.wait(.25)
	
	emit.emitvfx(unit.Bag1.Attachment)
	emit.enablevfx(unit.Bag1.Attachment,true)

	task.spawn(function()
		for i=0,2,1 do
			task.wait(.1)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 58, 196)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(84, 41, 255)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(48, 255, 37)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 55, 58)),0.00000000005,.5,"Mid",true,5,.5,1.6)
		end
	end)	

	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.45,Enum.EasingStyle.Quart,Enum.EasingDirection.Out,0),{CFrame =rt.CFrame + Vector3.new(0,5,0)})
	--TweenComplete:Play()
	
	task.wait(.6)
	

	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame =rt.CFrame + Vector3.new(0,-15,0)})
	TweenComplete:Play()
	
	task.wait(.25)
	emit.enablevfx(unit.Bag1.Attachment,false)

	local imp = script.Atk2Impact:Clone() 
	imp.Parent = workspace.Effects
	imp.Position = rt.Position + Vector3.new(0,-1,0)
	emit.emitvfx(imp)
	debris.AddItem(imp,3)
	
	for i = 0,6,1 do
		task.wait(.02)
		task.spawn(function()
			local Presenet = script.Present:Clone() -- vfx
			Presenet.Parent = workspace.Effects
			Presenet.CFrame = unit.Bag1.CFrame 
			emit.enablevfx(Presenet.Enable,true)
			debris.AddItem(Presenet,3)
			emit.emitvfx(Presenet)
			local Tweenrotate = tween_service:Create(Presenet,TweenInfo.new(.4,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,true),{Orientation = Presenet.Orientation + Vector3.new(90,90,90)})
			Tweenrotate:Play()

			local orientationpart = Instance.new("Part")
			orientationpart.Transparency = 1
			orientationpart.Anchored = true
			orientationpart.CanQuery = false
			orientationpart.CanTouch = false
			orientationpart.CanCollide = false
			orientationpart.Position = startpos.Position

			orientationpart.Orientation = Vector3.new(0,math.random(-360,360),0)

			local endpos = orientationpart.CFrame + (orientationpart.CFrame.LookVector * math.random(7,13))


			Presenet.CFrame = CFrame.lookAt(Presenet.Position, endpos.Position)


			local PointA = Presenet.CFrame 
			local PointB = Presenet.CFrame + (rt.CFrame.LookVector * 4) + Vector3.new(0,11,0)
			local PointC = endpos + Vector3.new(0,-1,0)

			task.spawn(function()
				for d=0,1,.057 do
				--	Presenet.CFrame = CFrame.lookAt(Presenet.Position, endpos.Position)
					Presenet.CFrame = CFrame.new(Bezier(d,PointA.Position,PointB.Position,PointC.Position))
					wait(0.00000000000000055)
				end			

				emit.enablevfx(Presenet.Enable,false)
				Presenet.Transparency = 1
				local impact = script.PresentImpact2:Clone() -- vfx
				impact.Parent = workspace.Effects
				impact.Position = Presenet.Position
				emit.emitvfx(impact)
				debris.AddItem(impact,1)

			end)
		end)
	
		
	end
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
