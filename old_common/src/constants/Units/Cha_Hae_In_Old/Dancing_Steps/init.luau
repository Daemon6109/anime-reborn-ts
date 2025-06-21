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
local Scaler = require(Replicated.Libs.VFX_Scale)

module.config = {
	HitDelay = .75, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .07, -- delay between hits in a multi-hit move
	Speed = 65,
	--CustomDelay = {
	--	[1] = .35,
	--},
	ScaleFactor = .75,
}

Scaler:scale(module.config.ScaleFactor, Mesh)

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

	local anim = AnimModule.PlayAnim(Animations["Strike"], unit, 1, "", {Weight = 2, Fade = .15})

	task.wait(.35)
	
	SoundWrapper:PlaySound(Sound.Slash, rt, Replicated.SoundGroups.UnitSFX)

	local model = Mesh["Strike"]:Clone()
	model:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(0,0,-17.5*self.config.ScaleFactor or 1) * CFrame.Angles(math.rad(-90),0,0))
	model.Parent = workspace.Effects
	debris.AddItem(model,5)

	model.Dash.CFrame *= CFrame.new(0,-22.5*self.config.ScaleFactor or 1,0)
	model.Beam_.CFrame *= CFrame.new(0,-22.5*self.config.ScaleFactor or 1,0)


	local dur = .35

	local c = Mesh.Ground:Clone()
	c:SetPrimaryPartCFrame(rt.CFrame)
	c.Parent = workspace.Effects
	debris.AddItem(c,7)

	vfx_custom.EmitAttr(c.Crack)
	vfx_custom.EmitAttr(c.Ground)


	vfx_custom.Particle(model.Dash,dur)
	vfx_custom.Particle(model.Shards,dur)
	vfx_custom.Particle(model.Strike,dur)

	vfx_custom.Particle(model.Beam_,dur)

	vfx_custom.Beam(model.Beam,.25,.1,.1,1)

	tween_service:Create(model.Beam_,TweenInfo.new(.2),{CFrame = model.Beam_.CFrame * CFrame.new(0,22.5*self.config.ScaleFactor or 1,0)}):Play()
	tween_service:Create(model.Dash,TweenInfo.new(.2),{CFrame = model.Dash.CFrame * CFrame.new(0,32.5*self.config.ScaleFactor or 1,0)}):Play()
	delay(.15,function()
		vfx_custom.Beam(model.Beam_,.15,.1,.1,1)
		vfx_custom.Beam(model.Wind,.35,.15,.15,1.25)
		vfx_custom.Beam(model.Wind_,.35,.15,.15,1.25)

		rt.CFrame = rt.CFrame * CFrame.new(0,0,-32.5*self.config.ScaleFactor or 1)

		local c = Mesh.Ground:Clone()
		c:SetPrimaryPartCFrame(rt.CFrame)
		c.Parent = workspace.Effects
		debris.AddItem(c,7)

		vfx_custom.EmitAttr(c.Crack)
		vfx_custom.EmitAttr(c.Ground)

		vfx_custom.EmitAttr(model.Slash)
		vfx_custom.Particle(model.Slash,.35)

		task.wait(1)
		tp(rt.CFrame,o)
		task.wait(.15)
		rt.CFrame = o
	end)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
