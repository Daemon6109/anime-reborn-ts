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
	HitDelay = 1.95, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
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
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	emit.enablevfx(unit.Sword,true)
	
	task.spawn(function()
		for i=0,6,1 do
			task.wait(.06)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 82, 85)),0.00000000005,.5,"Mid",true,5,.5,1.1)
		end
	end)
	
	task.wait(.15)
		
		
	local endpos = rt.CFrame + (rt.CFrame.LookVector * 10)	
	
	local start = script:FindFirstChild("Atk2Charge"):Clone()
	start.Parent = effectsfolder
	start.Position = rt.Position + Vector3.new(0,-1.3,0)
	debris.AddItem(start,4)
	emit.emitvfx(start)	
	emit.enablevfx(start,true)	
	
	task.wait(.7)
	
	emit.enablevfx(unit.Torso.Aroundslashes,true)	
	
	AnimModule.ChangeAnimSpeed(ANIMM,.7)

	
	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = endpos}) 
	TweenComplete:Play()	
	local TweenComplete = tween_service:Create(start,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = endpos}) 
	TweenComplete:Play()	
	task.wait(.8)
	emit.enablevfx(start,false)	

	emit.emitvfx(start)	
	emit.enablevfx(unit.Torso.Aroundslashes,false)	
	task.wait(.2)
	
	local slashend = script:FindFirstChild("Atk2Impact"):Clone()
	slashend.Parent = effectsfolder
	slashend.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	debris.AddItem(slashend,4)
	emit.emitvfx(slashend)	
	emit.enablevfx(unit.Sword,false)

	task.wait(.83)
	
	local TP = script.AkameTp:Clone() 
	TP.Parent = workspace.Effects
	TP.CFrame = rt.CFrame
	EmitParticles(TP)
	debris.AddItem(TP,3)

	task.wait(.05)
	rt.CFrame = startpos
	task.wait(0.05)
	local TP2 = script.AkameTpReappear:Clone() 
	TP2.Parent = workspace.Effects
	TP2.CFrame = rt.CFrame
	EmitParticles(TP2)
	debris.AddItem(TP2,3)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
