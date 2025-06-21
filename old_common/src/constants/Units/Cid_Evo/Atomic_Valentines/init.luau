local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)
local rn = game:GetService("RunService")

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

module.config = {
	HitDelay = 2.95, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

function Beam(model,dur,t,t2,x)
	for i,v in pairs(model:GetChildren()) do
		if v:IsA('Beam') then
			local w0 = v.Width0 
			local w1 = v.Width1

			v.Width0 = 0
			v.Width1 = 0

			v.Enabled = true

			if t == nil then
				t = .15
			end

			if t2 == nil then
				t2 = .15
			end

			if x == nil then
				x = 2
			end

			tween_service:Create(v,TweenInfo.new(t2),{Width0 = w0*x;Width1 = w0*x}):Play()
			delay(.1,function()
				tween_service:Create(v,TweenInfo.new(t),{Width0 = w0;Width1 = w1}):Play()
				delay(dur,function()
					tween_service:Create(v,TweenInfo.new(t),{Width0 = 0;Width1 = 0}):Play()
				end)
			end)

		end
	end
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1.2, "", {Weight = 2, Fade = .15})
	task.spawn(function()
		task.wait(0.5)
		SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	end)
	task.wait(1.2)
	local humrp = rt
	local Enemy = pos
	
	task.spawn(function()
		for i = 1,12 do

			task.spawn(function()
				local en = script.Aura:Clone()

				en.CFrame = humrp.CFrame * CFrame.new(math.random(-12.5,12.5),math.random(-1.5,3),math.random(-12.5,12.5))
				en.Parent = effectsfolder
				debris.AddItem(en,6)

				local cf_ = humrp.CFrame * CFrame.new(math.random(-12.5,12.5),math.random(-1.5,20),math.random(-12.5,12.5))
				local start = en.Position
				local finish = cf_.Position
				local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-25,-15),math.random(-13,15),math.random(-10,10))

				if i%2 == 0 then
					middle = ((en.Position+finish)/2) + Vector3.new(math.random(15,25),math.random(-13,15),math.random(-10,10))
				end

				Particle(en,.35)

				local step = math.random(25,35)

				for i = 1,step do
					en.CFrame = CFrame.lookAt(en.Position,finish) 
					en.Position = quad(start,middle,finish,i/step)
					game:GetService('RunService').Heartbeat:Wait()
				end
			end)

			task.wait(.125)

		end
	end)

	task.spawn(function()
		local model = script.Casting:Clone()
		model:SetPrimaryPartCFrame(humrp.CFrame * CFrame.new(0,.5,0))
		model.Parent = effectsfolder
		debris.AddItem(model,9)

		local dur = 2

		task.spawn(function()
			for i = 1,5 do
				model.Sparkle:ScaleTo(model.Sparkle:GetScale() + .1)
				rn.Heartbeat:Wait()
			end

		end)

		Particle(model.Sparkle.Spark,.2)
		task.wait(.15)

		task.spawn(function()

			tween_service:Create(model.Particle.Charge.PL,TweenInfo.new(.5),{Brightness = 5;Range = 18}):Play()

			for i = 1,5 do
				model.Particle:ScaleTo(model.Particle:GetScale() + .1)
				rn.Heartbeat:Wait()
			end

			Beam(model.Particle.Charge["floor beams"],dur,.15,.15)

			Particle(model.Particle.Shards,dur)
			Particle(model.Particle.Charge,dur)
			Particle(model.Particle.Crack,dur)

			emit.emitvfx(model.Particle.Shards)
			emit.emitvfx(model.Particle.Charge)
			emit.emitvfx(model.Particle.Crack)

			task.delay(dur*1.5,function()
				tween_service:Create(model.Particle.Charge.PL,TweenInfo.new(2),{Brightness = 0;Range = 0}):Play()
			end)

		end)

		task.spawn(function()
			for i = 1,45 do
				model.Wind:SetPrimaryPartCFrame(model.Wind:GetPrimaryPartCFrame() * CFrame.Angles(0,math.rad(-2),0))
				rn.Heartbeat:Wait()
			end
		end)

		task.spawn(function()
			for i = 1,5 do
				model.Wind:ScaleTo(model.Wind:GetScale() + .1)
				rn.Heartbeat:Wait()
			end
		end)

		task.delay(dur,function()
			for i,v in pairs(model.Wind:GetChildren()) do
				tween_service:Create(v,TweenInfo.new(.5),{Transparency = 1}):Play()
			end
		end)

	end)

	task.wait(1.25)	
	task.wait(.25)

	task.spawn(function()
		local model = script.Explosion:Clone()
		model:SetPrimaryPartCFrame(humrp.CFrame * CFrame.new(0,-.15,0))
		model.Parent = effectsfolder
		debris.AddItem(model,7)

		local dur = 1

		task.spawn(function()
			for i = 1,5 do
				model.Sparkle:ScaleTo(model.Sparkle:GetScale() + .1)
				rn.Heartbeat:Wait()
			end

		end)

		Particle(model.Sparkle.Spark,.35)
		task.wait(.25)

		task.spawn(function()


			for i = 1,5 do
				model.Particle:ScaleTo(model.Particle:GetScale() + .15)
				rn.Heartbeat:Wait()
			end

			Beam(model.Particle.Floor.Beam,dur,.15,.15)
			Beam(model.Particle.Floor["floor beams"],dur,.15,.15)

			Beam(model.Particle.Beam,dur,.15,.15)

			Beam(model.Particle.W1,dur,.15,.15)
			Beam(model.Particle.W2,dur,.15,.15)
			Beam(model.Particle.W3,dur,.15,.15)
			Beam(model.Particle.W4,dur,.15,.15)

			Particle(model.Particle.Floor,dur)
			Particle(model.Particle.Shards,dur)
			Particle(model.Particle.Crack,dur)
			Particle(model.Particle.Crack_,dur)

			emit.emitvfx(model.Particle.Floor)
			emit.emitvfx(model.Particle.Shards)
			emit.emitvfx(model.Particle.Crack)
			emit.emitvfx(model.Particle.Crack_)

			task.delay(dur*1.15,function()
			end)

		end)

		task.spawn(function()
			for i = 1,90 do
				model.Wind:SetPrimaryPartCFrame(model.Wind:GetPrimaryPartCFrame() * CFrame.Angles(0,math.rad(-1),0))
				rn.Heartbeat:Wait()
			end
		end)

		task.spawn(function()
			for i = 1,5 do
				model.Wind:ScaleTo(model.Wind:GetScale() + .15)
				rn.Heartbeat:Wait()
			end
		end)

		task.delay(dur,function()
			for i,v in pairs(model.Wind:GetChildren()) do
				tween_service:Create(v,TweenInfo.new(.5),{Transparency = 1}):Play()
				emit.emitvfx(model)

			end
		end)
	end)

	task.wait(.5)

end

	

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
