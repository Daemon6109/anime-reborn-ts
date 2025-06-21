local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local VFXModule = require(Replicated.Libs.VFXModule)

module.config = {
	HitDelay = 1.6, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

    AnimModule.PlayAnim(script.Anim, unit, 1.35, "", {Weight = 2, Fade = .15})

    task.wait(.2)
    SoundWrapper:PlaySound(script.Vyasche1, rt)
    local Spin = script.Spin:Clone()
    Spin.CFrame = rt.CFrame * CFrame.Angles(0, 0, math.rad(-90))
    Spin.Parent = workspace.Effects
    VFXModule.Debris(Spin, 4)
    VFXModule.Emit(Spin)
    VFXModule.EffectToggle(Spin, true)

    TweenService:Create(Spin, TweenInfo.new(.5, Enum.EasingStyle.Quad), {CFrame = pos.CFrame * Spin.CFrame.Rotation}):Play()

    task.wait(.5)
    VFXModule.EffectToggle(Spin, false)
    local Explosion = script.MagicEdge:Clone()
    Explosion.CFrame = pos.CFrame
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
