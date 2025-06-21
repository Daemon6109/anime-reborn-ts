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
	HitDelay = 1.1, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
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

	local anim = AnimModule.PlayAnim(Animations["Air Slash"], unit, 1, "", {Weight = 2, Fade = .15})

	task.wait(.55)

	local model = Mesh["Air Slash"]:Clone()
	model:SetPrimaryPartCFrame(rt.CFrame)
	model.Parent = workspace.Effects
	debris.AddItem(model,5)

	local c = Mesh.Ground:Clone()
	c:SetPrimaryPartCFrame(rt.CFrame)
	c.Parent = workspace.Effects
	debris.AddItem(c,7)

	local function slash(i)
		vfx_custom.EmitAttr(c.Crack)
		vfx_custom.EmitAttr(c.Ground)

		local slash = model[tostring(i)].Air

		local dur = 1.5

		SoundWrapper:PlaySound(Sound.Air, rt, Replicated.SoundGroups.UnitSFX)
		vfx_custom.Emit(slash.Air,1)

		vfx_custom.Particle(slash.Air,dur+.25)
		vfx_custom.Particle(slash.Ground,dur)
		vfx_custom.Particle(slash.Strike,dur)

		vfx_custom.Beam(slash.Air,dur,.15,.15,1.25)
		vfx_custom.Beam(slash.Strike,dur,.15,.15,1.25)

		vfx_custom.Beam(slash.Wind,dur,.15,.15,1.25)
		vfx_custom.Beam(slash.Wind_,dur,.15,.15,1.25)

		local rng = 45
		if i == 4 or i == 5 then
			rng = 35
		end

		tween_service:Create(slash.Air,TweenInfo.new(2),{CFrame = slash.Air.CFrame * CFrame.new(rng,0,0)}):Play()
		tween_service:Create(slash.Air.PL,TweenInfo.new(.35),{Brightness = 1;Range = 12*self.config.ScaleFactor or 1}):Play()
		delay(dur,function()
			tween_service:Create(slash.Air.PL,TweenInfo.new(.35),{Brightness = 0;Range = 0}):Play()
		end)

	end

	task.wait(.3)
	vfx_custom.EmitAttr(model.Slash)
	SoundWrapper:PlaySound(Sound.Slash, rt, Replicated.SoundGroups.UnitSFX)
	slash(1)

	task.wait(.1)
	SoundWrapper:PlaySound(Sound.Blast, rt, Replicated.SoundGroups.UnitSFX)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
