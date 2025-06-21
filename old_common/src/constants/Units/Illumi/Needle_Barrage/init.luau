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
	HitDelay = .6, -- seconds
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

	AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    local Charge = script.Floor:Clone()
    Charge.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0)
    Charge.Parent = workspace.Effects
    VFXModule.EffectToggle(Charge, true)
    VFXModule.Debris(Charge, 4)

    task.wait(.5)

    local Barrage = script.NeedleBarrage:Clone()
    Barrage.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0)
    Barrage.Parent = workspace.Effects
    VFXModule.EffectToggle(Barrage, true)
    VFXModule.Debris(Barrage, 4)

    for i = 1, 20 do
        local Needle = script.Needle:Clone()
        Needle.CFrame = CFrame.new(rt.Position, rt.Position + Vector3.new(Rand:NextInteger(-30, 30), Rand:NextInteger(-10, 30), Rand:NextInteger(-30, 30)))
        Needle.Parent = workspace.Effects
        VFXModule.Emit(Needle)
        VFXModule.Debris(Needle, 2)
        task.wait(.1)
    end

    VFXModule.EffectToggle(Charge, false)
    VFXModule.EffectToggle(Barrage, false)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
