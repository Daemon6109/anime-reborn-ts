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
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
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
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.35)
	
	local jump = script["Jump"]:Clone() 
	jump.Parent = effectsfolder
	jump.Position = rt.Position + Vector3.new(0,-1,0)
	emit.emitvfx(jump)
	debris.AddItem(jump,3)

	local TweenCompletepo = tween_service:Create(rt,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = rt.CFrame + Vector3.new(0,3.5,0)})
	TweenCompletepo:Play()
	
	task.wait(.2)
	
	local TP = script.EvilEyeTp:Clone() 
	TP.Parent = workspace.Effects
	TP.CFrame = rt.CFrame
	EmitParticles(TP)
	debris.AddItem(TP,3)

	task.wait(.02)
	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + Vector3.new(0,3.5,0)

	task.wait(0.01)
	local TP2 = script["TpsRe-appear"]:Clone() 
	TP2.Parent = workspace.Effects
	TP2.CFrame = rt.CFrame 
	EmitParticles(TP2)
	debris.AddItem(TP2,3)
		
	task.wait(.1)
	
	local Down = script["StompGoDown"]:Clone() 
	Down.Parent = effectsfolder
	Down.Position = rt.Position + Vector3.new(0,-2,0)
	emit.emitvfx(Down)
	debris.AddItem(Down,3)
	SoundWrapper:PlaySound(script["Explosion"], rt, Replicated.SoundGroups.UnitSFX)

	local TweenCompletepo = tween_service:Create(rt,TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = rt.CFrame + Vector3.new(0,-3.5,0)})
	TweenCompletepo:Play()

	task.wait(.15)
	local Impct = script["Stomp"]:Clone() 
	Impct.Parent = effectsfolder
	Impct.Position = rt.Position + Vector3.new(0,-1.15,0)
	emit.emitvfx(Impct)
	debris.AddItem(Impct,3)
	
	
	task.wait(.7)
	
	local TP = script.EvilEyeTp:Clone() 
	TP.Parent = workspace.Effects
	TP.CFrame = rt.CFrame
	EmitParticles(TP)
	debris.AddItem(TP,3)

	task.wait(.02)
	rt.CFrame =startpos

	task.wait(0.01)
	local TP2 = script["TpsRe-appear"]:Clone() 
	TP2.Parent = workspace.Effects
	TP2.CFrame = rt.CFrame 
	EmitParticles(TP2)
	debris.AddItem(TP2,3)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
