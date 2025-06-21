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
	HitDelay = 3, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1.2, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.9)
	
	local chargeball = script:FindFirstChild("MaxSphereCharge"):Clone()
	chargeball.Parent = effectsfolder
	chargeball.CFrame = rt.CFrame + Vector3.new(0,7,0)
	debris.AddItem(chargeball, 4)
	EmitParticles(chargeball)
	
	task.wait(1)
	
	local ball = script:FindFirstChild("MaxSphere"):Clone()
	ball.Parent = effectsfolder
	ball.CFrame = rt.CFrame + Vector3.new(0,7,0)
	debris.AddItem(ball, 4)
	EmitParticles(ball)
	
	task.wait(.5)
	
	local send = script:FindFirstChild("ShootMaxSpehre"):Clone()
	send.Parent = effectsfolder
	send.CFrame = ball.CFrame + (rt.CFrame.LookVector * 4)
	debris.AddItem(send, 4)
	emit.emitvfx(send)
	
	send.CFrame = CFrame.lookAt(send.Position, pos.Position)
	emit.emitvfx(ball)
	local TweenCompletepo = tween_service:Create(ball,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = pos.CFrame})
	TweenCompletepo:Play()
	
	task.wait(.28)
	ball:Destroy()
	local impactenable = script:FindFirstChild("MaxSphereExplenable"):Clone()
	impactenable.Parent = effectsfolder
	impactenable.CFrame = pos.CFrame + Vector3.new(0,-1,0)
	debris.AddItem(impactenable, 4)
	EmitParticles(impactenable)
	
	task.wait(.85)
	
	local impact = script:FindFirstChild("MaxSphereExplode"):Clone()
	impact.Parent = effectsfolder
	impact.CFrame = pos.CFrame + Vector3.new(0,-1,0)
	debris.AddItem(impact, 4)
	EmitParticles(impact)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
