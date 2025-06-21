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
	HitDelay = .95, -- seconds
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
	

	emit.enablevfx(unit["Right Arm"],true)
	
	unit["Right Arm"].Bat1.Transparency = 0
	unit["Right Arm"].Bat2.Transparency = 0
	

	local fireball = script.FireBall:Clone()		
	fireball.Parent = effectsfolder
	fireball.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1.6)+ (rt.CFrame.RightVector * 0.4) + Vector3.new(0,0.25,0)
	emit.enablevfx(fireball,true)
	EmitParticles(fireball)
	
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local gragra = AnimModule.PlayAnim(script.Animation2, unit, 1.2, "Secibdabim", {Weight = 2, Fade = .4})

	task.wait(.5)
	
	local TweenComplete = tween_service:Create(fireball,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position =pos.Position})
	TweenComplete:Play()
	
	task.wait(.25)
	unit["Right Arm"].Bat1.Transparency = 1
	unit["Right Arm"].Bat2.Transparency = 1
	emit.enablevfx(unit,false)

	emit.enablevfx(fireball,false)

	local impat = script.FireBallExplosion:Clone()		
	impat.Parent = effectsfolder
	impat.Position = fireball.Position
	emit.emitvfx(impat)
	debris.AddItem(impat,3)
	
	task.wait(.3)
	
	emit.emitvfx(unit.Torso)
	AnimModule.ChangeAnimSpeed(gragra,6)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
