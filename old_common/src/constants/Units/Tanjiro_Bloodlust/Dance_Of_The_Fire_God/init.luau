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
	HitDelay = .4, -- seconds
	HitCount = 9, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
	CustomDelay = {
		[8] = .9,
	},
	EndingDelay = .25,
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

	local anim = AnimModule.PlayAnim(Animations["Dance of Fire God"], unit, 1.7, "", {Weight = 2, Fade = .15})

	tp(rt.CFrame,Enemy * CFrame.new(0,0,5))
	task.wait(.15)
	rt.CFrame = Enemy * CFrame.new(0,0,5)

	tween_service:Create(rt,TweenInfo.new(2),{CFrame = Enemy * CFrame.new(0,0,-10)}):Play()

	task.spawn(function()

		local model = Mesh["Burning Bones"]:Clone()
		model:SetPrimaryPartCFrame(rt.CFrame)
		model.Parent= workspace
		debris.AddItem(model,5)

		local function burst(i)
			local slash = model[tostring(i)]
			slash:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-2.5))

			local c = Mesh.Ground_:Clone()

			c:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-2.5))
			c.Parent = workspace.Effects
			debris.AddItem(c,7)

			vfx_custom.EmitAttr(c.Crack)
			vfx_custom.EmitAttr(c.Ground)

			SoundWrapper:PlaySound(Sound.Flash, rt, Replicated.SoundGroups.UnitSFX)
			if i %2 == 0 then
				SoundWrapper:PlaySound(Sound.Flame, rt, Replicated.SoundGroups.UnitSFX)
			else
				SoundWrapper:PlaySound(Sound.Splash, rt, Replicated.SoundGroups.UnitSFX)
			end

			vfx_custom.EmitAttr(slash.Slash)
			vfx_custom.EmitAttr(slash.Burst)	
			vfx_custom.EmitAttr(slash.Burst_)

			vfx_custom.EmitAttr(slash.Flames)
			vfx_custom.EmitAttr(slash.Flames_)

			tween_service:Create(slash.Slash.PointLight,TweenInfo.new(.35),{Brightness = 3;Range = 12}):Play()
			delay(.35,function()
				tween_service:Create(slash.Slash.PointLight,TweenInfo.new(.5),{Brightness = 0;Range = 0}):Play()
			end)

			task.spawn(function()
				for i_ = 1,2 do

					task.spawn(function()
						local en = Mesh.Aura:Clone()
						if i_%2 == 0 then
							en = Mesh.Aura_:Clone()
						end

						en.CFrame = slash.Origin.CFrame * CFrame.new(math.random(-3,3),math.random(-1.5,1.5),math.random(-5,-3))
						en.Parent = workspace.Effects
						debris.AddItem(en,5)

						local cf_ = slash.Origin.CFrame* CFrame.new(math.random(-25,25),math.random(-1,1),math.random(25,35))
						local start = en.Position
						local finish = cf_.Position
						local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-17,-7),math.random(-3,5),math.random(-15,15))

						if i_%2 == 0 then
							middle = ((en.Position+finish)/2) + Vector3.new(math.random(7,17),math.random(-3,5),math.random(-15,15))
						end

						vfx_custom.Particle(en,.35)

						local step = math.random(12.5,17.5)

						for i = 1,step do
							en.CFrame = CFrame.lookAt(en.Position,finish) 
							en.Position = quad(start,middle,finish,i/step)
							game:GetService('RunService').Heartbeat:Wait()
						end
					end)

					task.wait(.05)

				end
			end)

		end

		task.wait(.075)
		for i = 1,6 do
			burst(i)
			task.wait(.15)
		end

		task.wait(.0625)

		local c = Mesh.Ground_:Clone()

		c:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-2.5))
		c.Parent = workspace.Effects
		debris.AddItem(c,7)

		vfx_custom.EmitAttr(c.Crack)
		vfx_custom.EmitAttr(c.Ground)

		local burst = Mesh["Summers Sun"]:Clone()
		burst:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-15))
		burst.Parent = workspace.Effects
		debris.AddItem(burst,5)

		task.wait(.075)
		delay(.75,function()
			anim:Stop()
		end)

		SoundWrapper:PlaySound(Sound.Burst_re, rt, Replicated.SoundGroups.UnitSFX)
		SoundWrapper:PlaySound(Sound.Flame, rt, Replicated.SoundGroups.UnitSFX)

		vfx_custom.EmitAttr(burst.B1)
		vfx_custom.EmitAttr(burst.B2)
		vfx_custom.EmitAttr(burst.B3)
		vfx_custom.EmitAttr(burst.Crack)

		vfx_custom.Particle(burst.B1,.5)
		vfx_custom.Particle(burst.B2,.5)
		vfx_custom.Particle(burst.B3,.5)
		vfx_custom.Particle(burst.Crack,.5)

		burst.B1.Sparkle.Enabled = false
		burst.B2.Sparkle.Enabled = false
		burst.B3.Sparkle.Enabled = false

		tween_service:Create(burst.B2.PointLight,TweenInfo.new(.35),{Brightness = 3;Range = 25}):Play()
		delay(.5,function()
			tween_service:Create(burst.B2.PointLight,TweenInfo.new(.5),{Brightness = 0;Range = 0}):Play()
		end)

		task.spawn(function()
			for i_ = 1,4 do

				task.spawn(function()
					local en = Mesh.Aura_:Clone()

					en.CFrame =CFrame.new(burst.B1.Position) * CFrame.new(math.random(-15,15),math.random(-1.5,1.5),math.random(-3,3))
					en.Parent = workspace.Effects
					debris.AddItem(en,5)

					local cf_ = CFrame.new(burst.B1.Position) * CFrame.new(math.random(-35,35),math.random(-1,5),math.random(35,55))
					local start = en.Position
					local finish = cf_.Position
					local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-17,-8),math.random(-13,15),math.random(-35,-15))

					if i_%2 == 0 then
						middle = ((en.Position+finish)/2) + Vector3.new(math.random(8,17),math.random(-13,15),math.random(-35,-15))
					end

					vfx_custom.Particle(en,.35)

					local step = math.random(35,45)

					for i = 1,step do
						en.CFrame = CFrame.lookAt(en.Position,finish) 
						en.Position = quad(start,middle,finish,i/step)
						game:GetService('RunService').Heartbeat:Wait()
					end
				end)

				task.wait(.05)

			end
		end)

	end)

	task.wait(2)
	tp(rt.CFrame,o)
	task.wait(.15)
	rt.CFrame = o
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
