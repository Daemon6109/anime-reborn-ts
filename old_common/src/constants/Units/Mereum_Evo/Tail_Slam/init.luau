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
	HitDelay = .65, -- seconds
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

    AnimModule.PlayAnim(script.Anim, unit, 1.5, "", {Weight = 2, Fade = .15})

    local Dash = script.Dash:Clone()
    Dash.CFrame = rt.CFrame * CFrame.new(0, 0, -12) * CFrame.Angles(0, math.rad(90), 0)
    Dash.Parent = workspace.Effects
    VFXModule.Emit(Dash)
    VFXModule.Debris(Dash, 2)

    TweenService:Create(rt, TweenInfo.new(.65, Enum.EasingStyle.Quad), {CFrame = CFrame.new(pos.Position) * DefaultCFrame.Rotation * CFrame.new(0, 0, 2)}):Play()

    task.wait(.65)

    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = pos.CFrame
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)

    VFXModule.GroundExpandV2(CFrame.new(pos.Position), 8, 8, {baseDestroyWait = 1.5, expandTime = .2})
    
    task.wait(1)
    TweenService:Create(rt, TweenInfo.new(.5), {CFrame = DefaultCFrame}):Play()
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
