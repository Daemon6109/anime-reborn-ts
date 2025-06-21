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

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    TweenService:Create(rt, TweenInfo.new(.5), {CFrame = CFrame.new((CFrame.new(pos.Position) * CFrame.new(0, 6, 3)).Position, pos.Position)}):Play()

    task.wait(.5)

    local NeedleModel = script.Needle:Clone()
    local Needle = NeedleModel.PrimaryPart
    NeedleModel:PivotTo(rt.CFrame * CFrame.new(0, 0, -2) * CFrame.Angles(math.rad(-63), math.rad(180), math.rad(180)))
    NeedleModel.Parent = workspace.Effects
    VFXModule.Debris(NeedleModel, 3)
    VFXModule.Emit(NeedleModel)

    task.wait(.5)
    NeedleModel = script.Needle:Clone()
    local Needle = NeedleModel.PrimaryPart
    NeedleModel:PivotTo(rt.CFrame * CFrame.new(0, 0, -2) * CFrame.Angles(math.rad(-63), math.rad(180), math.rad(180)))
    NeedleModel.Parent = workspace.Effects
    VFXModule.Debris(NeedleModel, 3)
    VFXModule.Emit(NeedleModel)

    task.wait(.5)
    NeedleModel = script.Needle:Clone()
    local Needle = NeedleModel.PrimaryPart
    NeedleModel:PivotTo(rt.CFrame * CFrame.new(0, 0, -2) * CFrame.Angles(math.rad(-63), math.rad(180), math.rad(180)))
    NeedleModel.Parent = workspace.Effects
    VFXModule.Debris(NeedleModel, 3)
    VFXModule.Emit(NeedleModel)

    task.wait(1)
    rt.CFrame = DefaultCFrame

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
