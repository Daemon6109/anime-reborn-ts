local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local TweenService = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local VFXModule = require(Replicated.Libs.VFXModule)

module.config = {
	HitDelay = .85, -- seconds
	HitCount = 12, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .08, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Anim, unit, 1.5, "", {Weight = 2, Fade = .15})

    task.wait(.35)

    local SpinBarrage = script.Spin:Clone()
    SpinBarrage.CFrame = rt.CFrame
    SpinBarrage.Parent = workspace.Effects
    VFXModule.EffectToggle(SpinBarrage, true)
    VFXModule.Debris(SpinBarrage, 3)

    task.wait(1.5)
    VFXModule.EffectToggle(SpinBarrage, false)

end

return module