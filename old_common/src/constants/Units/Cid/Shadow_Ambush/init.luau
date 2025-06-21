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
local rn = game:GetService("RunService")

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

local function lerp(p0,p1,t)
	return p0*(1-t) + p1*t
end

local function quad(p0,p1,p2, t)
	local l1 = lerp(p0,p1,t)
	local l2 = lerp(p1,p2,t)
	local quad = lerp(l1,l2,t)
	return quad
end

function Particle(particle,dl)
	for i,v in pairs(particle:GetChildren()) do
		if v:IsA('ParticleEmitter') then
			v.Enabled = true

			delay(dl,function()
				v.Enabled = false
			end)
		elseif v:IsA('Attachment') then
			for i,v2 in pairs(v:GetChildren()) do
				if v2:IsA("ParticleEmitter") then
					v2.Enabled = true

					delay(dl,function()
						v2.Enabled = false
					end)
				end
			end
		end
	end
end


local function tp(humrp,cf)

	local x = {humrp,cf}

	for i = 1,2 do
		local model = script.Blink:Clone()
		model.CFrame = x[i]
		model.Parent = effectsfolder
		debris.AddItem(model,4)

		Particle(model,.35)
	end
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	task.wait(.45)

	local humrp = rt
	local Enemy = pos
	local o = humrp.CFrame


	tp(humrp.CFrame,Enemy.CFrame)
	task.wait(.15)
	humrp.CFrame = Enemy.CFrame

	local c = script.Ground:Clone()
	c.CFrame = humrp.CFrame * CFrame.new(0,-.75,0)
	c.Parent = effectsfolder
	debris.AddItem(c,3)

	local dur = .35

	emit.emitvfx(c)
	Particle(c,dur)

	task.wait(.45)

	local model = script["Shadow Strike"]:Clone()
	model:SetPrimaryPartCFrame(humrp.CFrame * CFrame.new(0,-.5,0))
	model.Parent = effectsfolder
	debris.AddItem(model,5)

	emit.emitvfx(model.Strike)
	Particle(model.Strike,.15)
	tween_service:Create(model.Strike,TweenInfo.new(.15),{CFrame = model.Strike.CFrame * CFrame.new(0,-15,0)}):Play()

	local dur = .35

	tween_service:Create(model.Explosion.Explosion.PL,TweenInfo.new(1),{Brightness = 5;Range = 22}):Play()
	for i = 1,10 do
		model.Sparkle:ScaleTo(model.Sparkle:GetScale() + .1)
		rn.Heartbeat:Wait()
	end

	Particle(model.Sparkle.Spark,.2)
	task.wait(.15)

	task.spawn(function()
		for i = 1,10 do
			model.Sparkle:ScaleTo(model.Sparkle:GetScale() - .1)
			rn.Heartbeat:Wait()
		end
	end)

	task.spawn(function()
		for i = 1,10 do
			model.Explosion:ScaleTo(model.Explosion:GetScale() + .1)
			rn.Heartbeat:Wait()
		end

		Particle(model.Explosion.Explosion,dur)
		Particle(model.Explosion.Crack,dur)
		Particle(model.Explosion.Shards,dur)

		emit.emitvfx(model.Explosion.Explosion)
		emit.emitvfx(model.Explosion.Crack)
		emit.emitvfx(model.Explosion.Shards)


		task.delay(dur*1.5,function()
			tween_service:Create(model.Explosion.Explosion.PL,TweenInfo.new(2),{Brightness = 0;Range = 0}):Play()
			emit.emitvfx(model.Explosion.Crack)

		end)

	end)

	task.spawn(function()
		for i = 1,90 do
			model.Wind:SetPrimaryPartCFrame(model.Wind:GetPrimaryPartCFrame() * CFrame.Angles(0,math.rad(-1),0))
			rn.Heartbeat:Wait()
		end
	end)

	task.spawn(function()
		for i = 1,10 do
			model.Wind:ScaleTo(model.Wind:GetScale() + .1)
			rn.Heartbeat:Wait()
		end
	end)

	task.delay(dur*2,function()
		for i,v in pairs(model.Wind:GetChildren()) do
			tween_service:Create(v,TweenInfo.new(.5),{Transparency = 1}):Play()
		end

	end)

	task.wait(.5)

	tp(humrp.CFrame,o)
	task.wait(.15)
	humrp.CFrame = o
	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
