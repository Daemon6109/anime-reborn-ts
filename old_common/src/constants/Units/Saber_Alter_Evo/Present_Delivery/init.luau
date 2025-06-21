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
	HitDelay = 1.1, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.2, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	
	emit.emitvfx(unit.Planee.flares)
	
	unit.Planee.Transparency = 1
	
	emit.enablevfx(unit.Planee,false)
	
	task.wait(.35)
	
	
	local present = script.Present:Clone() 
	present.Parent = workspace.Effects
	present.CFrame = unit["Right Arm"].RightGripAttachment.WorldCFrame
	emit.emitvfx(present)
	debris.AddItem(present,3)

	emit.emitvfx(present.Appear)
	emit.enablevfx(present.Enable,true)
	
	local TweenComplete = tween_service:Create(present,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,true),{Position = present.Position + Vector3.new(0,1.5,0)})
	TweenComplete:Play()
	
	local Tweenrotate = tween_service:Create(present,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,true),{Orientation = present.Orientation + Vector3.new(90,90,90)})
	Tweenrotate:Play()

	task.spawn(function()
		for i=0,4,1 do
			task.wait(.06)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 58, 196)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(84, 41, 255)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(48, 255, 37)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 55, 58)),0.00000000005,.5,"Mid",true,5,.5,1.6)
		end
	end)	
	
	task.wait(.4)
	
	TweenComplete:Cancel()
	
	emit.emitvfx(present.Appear)

	local TweenComplete = tween_service:Create(present,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position =pos.Position})
	TweenComplete:Play()
	
	task.wait(.25)
	emit.enablevfx(present.Enable,false)

	local presentimpact = script.PresentImpact:Clone() 
	presentimpact.Parent = workspace.Effects
	presentimpact.Position = pos.Position
	emit.emitvfx(presentimpact)
	debris.AddItem(presentimpact,3)

	emit.emitvfx(unit.Planee.flares)

	unit.Planee.Transparency = 0

	emit.enablevfx(unit.Planee,true)
	unit.Planee.flares.Enabled = false
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
