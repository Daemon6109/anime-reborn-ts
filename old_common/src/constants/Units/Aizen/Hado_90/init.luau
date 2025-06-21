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
	HitDelay = 2.1, -- seconds
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


	local c = script.Ground:Clone()
	c:SetPrimaryPartCFrame(humrp.CFrame)
	c.Parent = effectsfolder
	debris.AddItem(c,5)

	local dur = 2

	Particle(c.Crack,dur)
	Particle(c.Ground,dur)

	Particle(unit.Acc.Charge,dur)
	tween_service:Create(unit.Acc.Charge.PL,TweenInfo.new(.35),{Range= 8;Brightness = 1}):Play()
	delay(dur,function()
		tween_service:Create(unit.Acc.Charge.PL,TweenInfo.new(.35),{Range= 0;Brightness = 0}):Play()
	end)

	task.spawn(function()
		for i = 1,12 do

			task.spawn(function()
				local en = script.Aura:Clone()
				if i%4 == 0 then
					en = script.Aura_:Clone()
				end

				en.CFrame = humrp.CFrame * CFrame.new(math.random(-5,5),math.random(-3,7),math.random(-12.5,12.5))
				en.Parent = effectsfolder
				debris.AddItem(en,5)

				local cf_ = unit["Left Arm"].CFrame
				local start = en.Position
				local finish = cf_.Position
				local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-25,-15),math.random(-3,5),math.random(-10,10))

				if i%2 == 0 then
					middle = ((en.Position+finish)/2) + Vector3.new(math.random(15,25),math.random(-3,5),math.random(-10,10))
				end

				Particle(en,.35)

				local step = math.random(20,25)

				for i = 1,step do
					en.CFrame = CFrame.lookAt(en.Position,finish) 
					en.Position = quad(start,middle,finish,i/step)
					game:GetService('RunService').Heartbeat:Wait()
				end
			end)

			task.wait(.15)

		end
	end)

	task.wait(.45)

	local model = script.Kurohitsugi:Clone()
	model:SetPrimaryPartCFrame(Enemy.CFrame)
	model.Parent = effectsfolder
	debris.AddItem(model,5)

	local dur = 2

	Particle(model.Ground,dur)
	Particle(model.back,dur)
	Particle(model.front,dur)
	Particle(model.left,dur)
	Particle(model.lines,dur)
	Particle(model.right,dur)
	Particle(model.top,dur)

	tween_service:Create(model.Ground.PointLight,TweenInfo.new(.5),{Range = 25;Brightness = 1}):Play()
	delay(dur,function()
		tween_service:Create(model.Ground.PointLight,TweenInfo.new(.5),{Range = 0;Brightness = 0}):Play()
	end)

	task.spawn(function()
		for i = 1,12 do

			task.spawn(function()
				local en = script.Aura:Clone()

				en.CFrame = Enemy.CFrame * CFrame.new(math.random(-10,10),math.random(-1.5,3),math.random(-10,10))
				en.Parent = effectsfolder
				debris.AddItem(en,5)

				local cf_ = Enemy.CFrame * CFrame.new(math.random(-25,25),math.random(20,30),math.random(-25,25))
				local start = en.Position
				local finish = cf_.Position
				local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-25,-10),math.random(-3,15),math.random(-20,20))

				if i%2 == 0 then
					middle = ((en.Position+finish)/2) + Vector3.new(math.random(10,25),math.random(-3,15),math.random(-20,20))
				end

				Particle(en,.35)

				local step = math.random(35,45)

				for i = 1,step do
					en.CFrame = CFrame.lookAt(en.Position,finish) 
					en.Position = quad(start,middle,finish,i/step)
					game:GetService('RunService').Heartbeat:Wait()
				end
			end)

			task.wait(.1)

		end
	end)
	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
