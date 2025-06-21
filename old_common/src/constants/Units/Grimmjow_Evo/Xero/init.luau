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
	HitDelay = 2, -- seconds
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

	local c = script.Ground_:Clone()
	c.CFrame = humrp.CFrame * CFrame.new(0,-.75,0)
	c.Parent = effectsfolder
	debris.AddItem(c,5)

	local dur = 1

	emit.emitvfx(c)
	Particle(c,dur+1.25)

	task.wait(.15)

	task.spawn(function()
		for i = 1,4 do

			task.spawn(function()
				local en = script.Aura_:Clone()

				en.CFrame = humrp.CFrame * CFrame.new(math.random(-12.5,12.5),math.random(-1.5,10),math.random(-12.5,12.5))
				en.Parent = workspace
				debris.AddItem(en,5)

				local cf_ = unit["Left Arm"].CFrame
				local start = en.Position
				local finish = cf_.Position
				local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-25,-15),math.random(-13,15),math.random(-10,10))

				if i%2 == 0 then
					middle = ((en.Position+finish)/2) + Vector3.new(math.random(15,25),math.random(-13,15),math.random(-10,10))
				end

				Particle(en,.35)

				local step = math.random(20,25)

				for i = 1,step do
					en.CFrame = CFrame.lookAt(en.Position,finish) 
					en.Position = quad(start,middle,finish,i/step)
					game:GetService('RunService').Heartbeat:Wait()
				end
			end)

			task.wait(.05)

		end
	end)

	task.spawn(function()

		for i = 1,9 do
			unit.Acc.Charge:ScaleTo(unit.Acc.Charge:GetScale() + .1)
			rn.Heartbeat:Wait()
		end

		emit.emitvfx(unit.Acc.Charge.c)

		delay(dur-.35,function()
			for i = 1,9 do
				unit.Acc.Charge:ScaleTo(unit.Acc.Charge:GetScale() - .1)
				rn.Heartbeat:Wait()
			end

			unit.Acc.Charge:ScaleTo(.01)
		end)

	end)

	Particle(unit.Acc.Charge.c,dur-.25)

	tween_service:Create(unit.Acc.Charge.c.PL,TweenInfo.new(.35),{Range = 12;Brightness = 3}):Play()
	delay(dur-.25,function()
		emit.emitvfx(c)
		tween_service:Create(unit.Acc.Charge.c.PL,TweenInfo.new(.5),{Range = 0;Brightness = 0}):Play()
	end)

	task.wait(dur-.35)

	local ki = script.GranReyCero:Clone()
	ki:SetPrimaryPartCFrame(humrp.CFrame)
	ki.Parent = workspace
	game.Debris:AddItem(ki,5)

	tween_service:Create(ki.Ki.PL,TweenInfo.new(.15),{Range = 12;Brightness = 3}):Play()
	for i = 1,9 do
		ki:ScaleTo(ki:GetScale() + .1)
		rn.Heartbeat:Wait()
	end

	tween_service:Create(ki.Ki,TweenInfo.new(.25),{CFrame = Enemy.CFrame}):Play()
	task.wait(.25)

	tween_service:Create(ki.Ki.PL,TweenInfo.new(.35),{Range = 0;Brightness = 0}):Play()
	for i = 1,9 do
		ki:ScaleTo(ki:GetScale() - .1)
		rn.Heartbeat:Wait()
	end

	local model = script.Explosion:Clone()
	model:SetPrimaryPartCFrame(Enemy.CFrame)
	model.Parent = effectsfolder
	debris.AddItem(model,5)

	local dur = 1

	tween_service:Create(model.Explosion.Explosion.PL,TweenInfo.new(1),{Brightness = 3;Range = 22}):Play()
	for i = 1,10 do
		model.Sparkle:ScaleTo(model.Sparkle:GetScale() + .125)
		rn.Heartbeat:Wait()
	end

	Particle(model.Sparkle.Spark,.2)
	task.wait(.15)

	task.spawn(function()
		for i = 1,10 do
			model.Sparkle:ScaleTo(model.Sparkle:GetScale() - .125)
			rn.Heartbeat:Wait()
		end
	end)

	task.spawn(function()
		for i = 1,10 do
			model.Explosion:ScaleTo(model.Explosion:GetScale() + .09)
			rn.Heartbeat:Wait()
		end

		Particle(model.Explosion.Explosion,dur)
		Particle(model.Explosion.Crack,dur)
		Particle(model.Explosion.Shards,dur)

		emit.emitvfx(model.Explosion.Explosion)
		emit.emitvfx(model.Explosion.Crack)


		task.delay(dur*1.15,function()
			tween_service:Create(model.Explosion.Explosion.PL,TweenInfo.new(2),{Brightness = 0;Range = 0}):Play()

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
			model.Wind:ScaleTo(model.Wind:GetScale() + .09)
			rn.Heartbeat:Wait()
		end
	end)

	task.delay(dur,function()
		for i,v in pairs(model.Wind:GetChildren()) do
			tween_service:Create(v,TweenInfo.new(.5),{Transparency = 1}):Play()
		end

	end)

	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
