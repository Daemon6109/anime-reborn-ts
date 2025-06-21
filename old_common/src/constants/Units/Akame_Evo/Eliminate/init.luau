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
	HitDelay = 1.2, -- seconds
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

	task.wait(0.2)
	
	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.4,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = rt.CFrame + Vector3.new(0,7.5,0)})
	TweenComplete:Play()	
	
	emit.emitvfx(unit.Torso.jump)
	
	task.wait(.4)
	
	local TP = script.AkameTp:Clone() 
	TP.Parent = workspace.Effects
	TP.CFrame = rt.CFrame
	EmitParticles(TP)
	debris.AddItem(TP,3)
	
	task.wait(.05)
	
	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector* -3.6) + Vector3.new(0,7,0)
	
	local TP2 = script.AkameTpReappear:Clone() 
	TP2.Parent = workspace.Effects
	TP2.CFrame = rt.CFrame
	EmitParticles(TP2)
	debris.AddItem(TP2,3)
	
	task.wait(.25)
		
	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = rt.CFrame + Vector3.new(0,-7.15,0)})
	TweenComplete:Play()	
	
	task.wait(.1)
	
	local hit = script.Backstab:Clone() 
	hit.Parent = workspace.Effects
	hit.CFrame = rt.CFrame + Vector3.new(0,-3.5,0) + (rt.CFrame.LookVector * 1)
	EmitParticles(hit)
	debris.AddItem(hit,3)
	
	task.wait(.6)
	
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

	
	task.wait(1)
	
	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
