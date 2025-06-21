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
	HitDelay = .75, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
	Speed = 65,
	--CustomDelay = {
	--	[1] = .35,
	--},
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

	local anim = AnimModule.PlayAnim(Animations["X Slash"], unit, 1, "", {Weight = 2, Fade = .15})

	local c = Mesh.Ground:Clone()
	c:SetPrimaryPartCFrame(rt.CFrame)
	c.Parent = workspace
	debris.AddItem(c,7)

	vfx_custom.EmitAttr(c.Crack)
	vfx_custom.EmitAttr(c.Ground)

	task.wait(.4)

	local model = Mesh["X Slash"]:Clone()
	model:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-15) * CFrame.Angles(math.rad(-90),0,0))
	model.Parent = workspace
	debris.AddItem(model,5)

	local dis = 22.5
	model.Dash.CFrame *= CFrame.new(0,-dis,0)

	local dur = .35

	vfx_custom.Particle(model.Dash,dur)
	vfx_custom.Particle(model.Shards,dur)
	vfx_custom.Particle(model.Strike,dur)

	vfx_custom.Beam(model.Wind,dur,.15,.15,1.25)
	vfx_custom.Beam(model.Wind_,dur,.15,.15,1.25)

	SoundWrapper:PlaySound(Sound.Slash, rt, Replicated.SoundGroups.UnitSFX)
	vfx_custom.EmitAttr(model.Dash) 

	delay(.25,function()
		model.Burst.Sparkle.Enabled = false
	end)

	tween_service:Create(model.Dash,TweenInfo.new(.2),{CFrame = model.Dash.CFrame * CFrame.new(0,dis,0)}):Play()
	delay(.15,function()

		rt.CFrame *= CFrame.new(0,0,-(dis+7.5))

		vfx_custom.EmitAttr(model.Slash)
		vfx_custom.EmitAttr(model.Slash_)
		vfx_custom.EmitAttr(model.Shards)

		vfx_custom.Particle(model.Burst,.35)
		vfx_custom.EmitAttr(model.Burst)

		tween_service:Create(model.Burst.PointLight,TweenInfo.new(.35),{Brightness = 3;Range = 15}):Play()
		delay(.35,function()
			tween_service:Create(model.Burst.PointLight,TweenInfo.new(.5),{Brightness = 0;Range = 0}):Play()
		end)

		c:SetPrimaryPartCFrame(rt.CFrame)

		vfx_custom.EmitAttr(c.Crack)
		vfx_custom.EmitAttr(c.Ground)

		vfx_custom.Particle(c.Crack,.5)
		vfx_custom.Particle(c.Ground,.5)


		task.wait(.75)
		tp(rt.CFrame,o)
		task.wait(.15)
		rt.CFrame = o


	end)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
