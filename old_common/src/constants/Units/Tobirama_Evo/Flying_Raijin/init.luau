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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.2, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local humrp = rt
	local Enemy = pos

	local o = humrp.CFrame

	local c = script.Ground:Clone()
	c:SetPrimaryPartCFrame(humrp.CFrame)
	c.Parent = effectsfolder
	debris.AddItem(c,5)

	emit.emitvfx(c.Crack)
	emit.emitvfx(c.Ground)

	task.wait(.35)

	local model = script["Flying Raijin"]:Clone()
	model:SetPrimaryPartCFrame(humrp.CFrame * CFrame.new(0,0,-15) * CFrame.Angles(math.rad(-90),0,0))
	model.Parent = effectsfolder
	debris.AddItem(model,5)

	local dis = 15
	model.Dash.CFrame *= CFrame.new(0,-dis,0)

	local dur = .35

	Particle(model.Dash,dur)
	Particle(model.Shards,dur)
	Particle(model.Strike,dur)

	Beam(model.W1,dur,.15,.15,1.25)
	Beam(model.W2,dur,.15,.15,1.25)
	Beam(model.W3,dur,.15,.15,1.25)

	emit.emitvfx(model.Strike) 
	emit.emitvfx(model.Beam_)

	tween_service:Create(model.Dash,TweenInfo.new(.1),{CFrame = model.Dash.CFrame * CFrame.new(0,dis,0)}):Play()
	task.delay(.05,function()

		humrp.CFrame *= CFrame.new(0,0,-(dis))

		c:SetPrimaryPartCFrame(humrp.CFrame)

		emit.emitvfx(c.Crack)
		emit.emitvfx(c.Ground)

		emit.emitvfx(model.Burst)


		task.wait(.5)
		tp(humrp.CFrame,o)
		task.wait(.15)
		humrp.CFrame = o

		c:SetPrimaryPartCFrame(humrp.CFrame)

		emit.emitvfx(c.Crack)
		emit.emitvfx(c.Ground)



	end)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
