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

	local anim = AnimModule.PlayAnim(Animations["Mutilate"], unit, 1, "", {Weight = 2, Fade = .15})

	local c = Mesh.Ground:Clone()
	c:SetPrimaryPartCFrame(rt.CFrame)
	c.Parent = workspace.Effects
	debris.AddItem(c,7)

	vfx_custom.EmitAttr(c.Crack)
	vfx_custom.EmitAttr(c.Ground)

	SoundWrapper:PlaySound(Sound.Dash, rt, Replicated.SoundGroups.UnitSFX)
	tp(rt.CFrame,Enemy)
	task.wait(.15)
	rt.CFrame = Enemy

	task.spawn(function()
		local c = Mesh.Ground:Clone()
		c:SetPrimaryPartCFrame(rt.CFrame)
		c.Parent = workspace.Effects
		debris.AddItem(c,7)

		vfx_custom.EmitAttr(c.Crack)
		vfx_custom.EmitAttr(c.Ground)

		vfx_custom.Particle(c.Crack,1.15)
		vfx_custom.Particle(c.Ground,1.15)
	end)

	SoundWrapper:PlaySound(Sound.Slash, rt, Replicated.SoundGroups.UnitSFX)
	task.wait(.15)
	SoundWrapper:PlaySound(Sound.Flash, rt, Replicated.SoundGroups.UnitSFX)
	
	task.spawn(function()
		for i = 1,5 do
			SoundWrapper:PlaySound(Sound.Slash, rt, Replicated.SoundGroups.UnitSFX)
			task.wait(.1)
		end
	end)

	local model = Mesh["Mutilate"]:Clone()
	model:SetPrimaryPartCFrame(rt.CFrame)
	model.Parent = workspace.Effects
	debris.AddItem(model,5)

	local dur = 1.15

	vfx_custom.EmitAttr(model.Slash)
	task.wait(.1)

	vfx_custom.Particle(model.Slash,dur)
	vfx_custom.Particle(model.Ground,dur)

	task.wait(dur-.25)
	vfx_custom.EmitAttr(model.Slash)

	tp(rt.CFrame,o)
	task.wait(.25)
	rt.CFrame = o

	vfx_custom.EmitAttr(c.Crack)
	vfx_custom.EmitAttr(c.Ground)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
