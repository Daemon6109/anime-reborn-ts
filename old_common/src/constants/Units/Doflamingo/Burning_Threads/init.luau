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

    AnimModule.PlayAnim(script.Anim, unit, .5, "", {Weight = 2, Fade = .15})

    TweenService:Create(rt, TweenInfo.new(.5), {CFrame = CFrame.new((CFrame.new(pos.Position) * CFrame.new(0, 12, 12)).Position, pos.Position)}):Play()

    task.wait(.5)

    local Barrage = script.Barrage:Clone()
    Barrage.CFrame = CFrame.lookAt(rt.Position, pos.Position) * CFrame.Angles(0, math.rad(-90), 0)
    Barrage.Parent = workspace.CurrentCamera
    VFXModule.Debris(Barrage, 3)
    VFXModule.EffectToggle(Barrage, true)

    for i = 1, 6 do
        local FireSlash = script.FireSlash:Clone()
        FireSlash.CFrame = rt.CFrame * CFrame.new(0, 0, -16) * CFrame.Angles(0, math.rad(90), math.rad(-90))
        FireSlash.Parent = workspace.Effects
        VFXModule.Debris(FireSlash, 2)
        VFXModule.Emit(FireSlash)

        task.wait(.3)
    end

    VFXModule.EffectToggle(Barrage, false)

    task.wait(.5)
    rt.CFrame = DefaultCFrame


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
