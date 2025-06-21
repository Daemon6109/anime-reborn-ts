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
	HitDelay = 1.25, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .25, -- delay between hits in a multi-hit move
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

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local ANIMM = AnimModule.PlayAnim(script["Shadow Clone"], unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	task.wait(.45)

	local humrp = rt
	local Enemy = pos
	local o = humrp.CFrame

	task.wait(.25)
	local c = script.Ground:Clone()
	c:SetPrimaryPartCFrame(humrp.CFrame)
	c.Parent = effectsfolder
	debris.AddItem(c,5)

	emit.emitvfx(c.Crack)
	emit.emitvfx(c.Ground)

	local cf = {-10,10}

	for i = 1,2 do

		task.spawn(function()

			local smoke = script.Smoke:Clone()
			smoke.CFrame = humrp.CFrame * CFrame.new(cf[i],0,0)
			smoke.Parent=  effectsfolder
			debris.AddItem(smoke,5)
			
			emit.emitvfx(smoke)				
			task.wait(.1)


			local clone = script.Tobi:Clone()
			clone:SetPrimaryPartCFrame(humrp.CFrame * CFrame.new(cf[i],0,0))
			clone.Parent = effectsfolder
			debris.AddItem(clone,5)

			local clone_humrp = clone.HumanoidRootPart
			local clone_hum = clone.Humanoid

			local c = script.Ground:Clone()
			c:SetPrimaryPartCFrame(clone_humrp.CFrame)
			c.Parent = effectsfolder
			debris.AddItem(c,5)

			emit.emitvfx(c.Crack)
			emit.emitvfx(c.Ground)


			clone_humrp.CFrame = CFrame.lookAt(clone_humrp.Position,Enemy.Position) 
	
			local ANIMM = AnimModule.PlayAnim(script["Shadow Clone"], clone, 1, "", {Weight = 2, Fade = .15})

			task.wait(.45)

			local model = script["Water Breath"]:Clone()
			model:SetPrimaryPartCFrame(clone_humrp.CFrame)
			model.Parent = effectsfolder
			debris.AddItem(model,5)

			local dur = 1

			emit.emitvfx(model.Water)
			Particle(model.Water,dur)
			Beam(model.Water,dur,.15,.15,math.random(1.25,1.65))

			task.wait(.15)

			task.wait(dur)
			emit.emitvfx(smoke)
			clone:Destroy()

		end)

	end

	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})

	task.wait(.55)

	local model = script["Water Breath"]:Clone()
	model:SetPrimaryPartCFrame(humrp.CFrame)
	model.Parent = effectsfolder
	debris.AddItem(model,5)

	local dur = 1

	emit.emitvfx(model.Water)
	Particle(model.Water,dur)
	Beam(model.Water,dur,.15,.15,math.random(1.25,1.65))

	task.wait(.15)

	emit.emitvfx(model.Blast)
	Particle(model.Blast,dur-.1)
	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
