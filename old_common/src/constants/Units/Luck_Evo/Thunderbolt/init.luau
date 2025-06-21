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
	HitDelay = 1.6, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local charge = script.Charge:Clone()
	charge.Parent = effectsfolder
	charge.CFrame = rt.CFrame * CFrame.new(-1.5,-0.3,1)
	for _,s in pairs(charge.Attachment:GetChildren()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(charge,3)


	task.wait(0.2)

	for _,s in pairs(charge.Emit:GetChildren()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end

	local blurshock = script.Blurshock:Clone()
	blurshock.CFrame = rt.CFrame * CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(180), 0)
	blurshock.Parent  = effectsfolder
	debris.AddItem(blurshock,3)

	tween_service:Create(blurshock.SpecialMesh, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
		Scale = Vector3.new(-0.055, -0.03, -0.055),
		Offset = Vector3.new(0, -2.5, 0),
		VertexColor = Vector3.one
	}):Play()

	tween_service:Create(blurshock, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
		Transparency = 1
	}):Play()

	local projectileonarm = script.Part.FX:Clone()
	projectileonarm.Parent = unit:FindFirstChild("Left Arm")
	projectileonarm.CFrame = CFrame.new(0,-1,0)
	for _,s in pairs(projectileonarm:GetChildren()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	task.delay(1.1, function()
		projectileonarm:Destroy()
	end)
	debris.AddItem(projectileonarm,3)

	task.wait(1)

	local shooteffect = script.ShootEffect:Clone()
	shooteffect.Parent = effectsfolder
	shooteffect.CFrame = rt.CFrame * CFrame.new(0.35,0,-3) * CFrame.Angles(math.rad(90),0,0)
	for _,s in pairs(shooteffect:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end

	local orb = script.Projectile:Clone()
	orb.Parent = effectsfolder
	orb.CFrame = rt.CFrame * CFrame.new(0,0,-2) 
	debris.AddItem(orb,3)

	local TweenComplete = tween_service:Create(orb,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame =CFrame.lookAt(pos.Position, pos.Position+SavedDirection)})
	TweenComplete:Play()


	task.wait(0.2)
	local explosion = script.SmallExplosion:Clone()
	explosion.Parent = effectsfolder
	explosion.CFrame = orb.CFrame 
	emit.enablevfx(orb,false)
	for _,s in pairs(explosion:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end

	debris.AddItem(explosion,3)


end
	


-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
