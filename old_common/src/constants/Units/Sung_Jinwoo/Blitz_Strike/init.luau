local module = {}
local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)
local vfx_custom = require(Replicated:WaitForChild("Libs"):WaitForChild("VFX_Custom"))
local Run = game:GetService("RunService")

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local Animations = script.Parent.Animations
local Mesh = script.Mesh
local Sound = script.Parent.Sound

module.config = {
	HitDelay = .8, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
	Speed = 80,
}

local function lerp(p0,p1,t)
	return p0*(1-t) + p1*t
end

local function quad(p0,p1,p2, t)
	local l1 = lerp(p0,p1,t)
	local l2 = lerp(p1,p2,t)
	local quad = lerp(l1,l2,t)
	return quad
end

local function tp(rt,cf)

	local x = {rt,cf}

	for i = 1,2 do
		local model = Mesh.Blink:Clone()
		model.CFrame = x[i]
		model.Parent = workspace.Effects
		debris.AddItem(model,5)

		vfx_custom.Particle(model,.35)
	end
end

function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local hum = unit:FindFirstChild("Humanoid")
	local SavedDirection = rt.CFrame.LookVector
	local Enemy = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)

	local o = rt.CFrame

	local anim = AnimModule.PlayAnim(Animations["Strike"], unit, 1.5, "", {Weight = 2, Fade = .15})

	local c = Mesh.Ground:Clone()
	c:SetPrimaryPartCFrame(rt.CFrame)
	c.Parent = workspace.Effects
	debris.AddItem(c,10)

	vfx_custom.EmitAttr(c.Crack)
	vfx_custom.EmitAttr(c.Ground)

	task.wait(.35)
	SoundWrapper:PlaySound(Sound.Slash, c, Replicated.SoundGroups.UnitSFX)

	local function blink(old,cf,x)

		for i = 1,2 do
			task.spawn(function()
				local en = Mesh.Aura:Clone()

				if x == true then
					en = Mesh.Aura_BL:Clone()
				end

				if i%2 == 0 then
					en = Mesh.Aura_:Clone()
				end

				en.CFrame = old * CFrame.new(math.random(-5,5),math.random(0,7.5),math.random(-5,5))
				en.Parent = workspace.Effects
				debris.AddItem(en,5)

				local cf_ = cf * CFrame.new(math.random(-3,3),math.random(-1,1),math.random(-3,3))
				local start = en.Position
				local finish = cf_.Position
				local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-10,-5),math.random(-3,5),math.random(-10,10))

				if i%2 == 0 then
					middle = ((en.Position+finish)/2) + Vector3.new(math.random(5,10),math.random(-3,5),math.random(-10,10))
				end

				vfx_custom.Particle(en,.35)

				local step = 12

				for i = 1,step do
					en.CFrame = CFrame.lookAt(en.Position,finish) 
					en.Position = quad(start,middle,finish,i/step)
					game:GetService('RunService').Heartbeat:Wait()
				end
			end)

			task.wait(.0001)

		end
	end

	local function dash(model)

		local dur = .25
		model.Dash.CFrame *= CFrame.new(0,-32.5,0)

		vfx_custom.Particle(model.Dash,dur)
		vfx_custom.Particle(model.Shards,dur)
		vfx_custom.Particle(model.Strike,dur)

		tween_service:Create(model.Dash,TweenInfo.new(.2),{CFrame = model.Dash.CFrame * CFrame.new(0,32.5,0)}):Play()
		delay(.15,function()
			vfx_custom.Particle(model.Burst,.25)				
			vfx_custom.EmitAttr(model.Strike)

			vfx_custom.EmitAttr(model.Slash)
			vfx_custom.EmitAttr(model.Slash_)

			vfx_custom.EmitAttr(model.Burst)
			vfx_custom.EmitAttr(model.Shards)

			tween_service:Create(model.Burst.PointLight,TweenInfo.new(.35),{Brightness = 1;Range = 12}):Play()
			delay(.35,function()
				tween_service:Create(model.Burst.PointLight,TweenInfo.new(.5),{Brightness = 0;Range = 0}):Play()
			end)
		end)

	end

	SoundWrapper:PlaySound(Sound.Flash, c, Replicated.SoundGroups.UnitSFX)

	for i = 1,8 do

		for i = 1,math.random(1,2) do
			task.spawn(function()
				local slash = Mesh["Strike"]:Clone()	
				slash:SetPrimaryPartCFrame(Enemy * CFrame.new(math.random(-12.5,12.5),math.random(0,15),math.random(-12.5,12.5))
					* CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180))))
				slash.Parent = workspace.Effects
				debris.AddItem(slash,5)

				dash(slash)	
				blink(rt.CFrame,slash.Burst.CFrame * CFrame.new(0,0,-5.5))
				rt.CFrame = slash.Burst.CFrame * CFrame.new(0,0,-5.5)

			end)
		end
		local r = math.random(1,2)

		if r == 1 then
			task.wait(.1)
		else
			task.wait(.05)
		end
	end

	local anim = AnimModule.PlayAnim(Animations["Back"], unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(Sound.Dash, c, Replicated.SoundGroups.UnitSFX)

	blink(rt.CFrame,o)
	tp(rt.CFrame,o)
	task.wait(.25)
	rt.CFrame = o
	c:SetPrimaryPartCFrame(rt.CFrame)

	vfx_custom.EmitAttr(c.Crack)
	vfx_custom.EmitAttr(c.Ground)

	vfx_custom.Particle(c.Crack,.5)
	vfx_custom.Particle(c.Ground,.5)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
