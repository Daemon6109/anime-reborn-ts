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
	HitDelay = .6, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
	EndingDelay = .25,
	Speed = 65,
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


	local anim = AnimModule.PlayAnim(Animations["Burning Bones"], unit, 2.75, "", {Weight = 2, Fade = .15})
	--anim:AdjustSpeed(2.75)

	task.wait(.15)

	SoundWrapper:PlaySound(Sound.Flame, rt, Replicated.SoundGroups.UnitSFX)
	SoundWrapper:PlaySound(Sound.Dance, rt, Replicated.SoundGroups.UnitSFX)

	task.spawn(function()

		local model = Mesh["Dance of Fire God"]:Clone()
		model:SetPrimaryPartCFrame(rt.CFrame)
		model.Parent= workspace
		debris.AddItem(model,5)

		for i = 1,8 do

			task.spawn(function()

				local rng = 2.5
				rt.CFrame = o * CFrame.new(math.random(-2.5,2.5),0,-(rng*i)) * CFrame.Angles(0,math.rad(math.random(-5,8)),math.rad(math.random(-8,8)))

				local slash = model["1"]:Clone()
				if i%2 == 0 then
					slash = model["2"]:Clone()
				end

				slash:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-2.5))
				slash.Parent = workspace.Effects
				debris.AddItem(slash,5)

				local c = Mesh.Ground_:Clone()

				c:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-2.5))
				c.Parent = workspace.Effects
				debris.AddItem(c,7)


				vfx_custom.EmitAttr(c.Crack)
				vfx_custom.EmitAttr(c.Ground)

				vfx_custom.EmitAttr(slash.Slash)
				vfx_custom.EmitAttr(slash.Burst)	
				vfx_custom.EmitAttr(slash.Burst_)

				tween_service:Create(slash.Slash.PointLight,TweenInfo.new(.35),{Brightness = 3;Range = 12}):Play()
				delay(.35,function()
					tween_service:Create(slash.Slash.PointLight,TweenInfo.new(.5),{Brightness = 0;Range = 0}):Play()
				end)

				task.spawn(function()
					for i_ = 1,1 do

						task.spawn(function()
							local en = Mesh.Aura_:Clone()

							en.CFrame = slash.Origin_.CFrame * CFrame.new(math.random(-3,3),math.random(-1.5,1.5),math.random(-3,3))
							en.Parent = workspace.Effects
							debris.AddItem(en,5)

							local cf_ = slash.Origin_.CFrame* CFrame.new(math.random(-5,8),math.random(-1,1),math.random(8,8))
							local start = en.Position
							local finish = cf_.Position
							local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-7,7),math.random(-3,5),math.random(-8,8))

							vfx_custom.Particle(en,.35)

							local step = math.random(25,35)

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

			task.wait(.05)

		end


		task.spawn(function()

			rt.CFrame = o

			local slash = model["1"]:Clone()

			slash:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-2.5))
			slash.Parent = workspace.Effects
			debris.AddItem(slash,3)

			local c = Mesh.Ground_:Clone()

			c:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-2.5))
			c.Parent = workspace.Effects
			debris.AddItem(c,7)

			vfx_custom.EmitAttr(c.Crack)
			vfx_custom.EmitAttr(c.Ground)

			vfx_custom.EmitAttr(slash.Slash)
			vfx_custom.EmitAttr(slash.Burst)	
			vfx_custom.EmitAttr(slash.Burst_)

			tween_service:Create(slash.Slash.PointLight,TweenInfo.new(.35),{Brightness = 3;Range = 12}):Play()
			delay(.35,function()
				tween_service:Create(slash.Slash.PointLight,TweenInfo.new(.5),{Brightness = 0;Range = 0}):Play()
			end)
		end)
	end)

	task.wait(.75)
	tp(rt.CFrame,o)
	task.wait(.15)
	rt.CFrame = o
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
