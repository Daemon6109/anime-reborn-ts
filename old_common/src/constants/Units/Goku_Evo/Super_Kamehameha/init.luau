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
	HitDelay = .35, -- seconds
	HitCount = 15, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	local Animation = AnimModule.PlayAnim(script.Anim, unit, 1.25, "Beam", {Weight = 2, Fade = .15})
    SoundWrapper:PlaySound(script.SuperKamehameha, rt)    

    local Charge = script.Ball:Clone()
    Charge.CFrame = unit["Right Arm"].CFrame * CFrame.new(0, -.5, 0)
    Charge.Parent = workspace.Effects
    VFXModule.EffectToggle(Charge, true)
    VFXModule.Debris(Charge, 4)
    VFXModule.WeldFunction(unit["Right Arm"], Charge, "ChargeWeld")

    task.wait(.35)
    VFXModule.EffectToggle(Charge, false)

    local Beam = script.Kamehameha:Clone()
    Beam.CFrame = rt.CFrame * CFrame.new(0, 0, -20) * CFrame.Angles(0, math.rad(90), 0)
    Beam.Parent = workspace.Effects
    VFXModule.Emit(Beam)
    VFXModule.EffectToggle(Beam, true)
    VFXModule.Debris(Beam, 4)
    AnimModule.ChangeAnimSpeed(Animation, 0)

    task.wait(1.5)
    AnimModule.ChangeAnimSpeed(Animation, 1)
    VFXModule.EffectToggle(Beam, false)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
