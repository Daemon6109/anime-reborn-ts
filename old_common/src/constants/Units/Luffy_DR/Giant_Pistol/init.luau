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

    AnimModule.PlayAnim(script.PistolAnim, unit, 1.35, "", {Weight = 2, Fade = .15})

    TweenService:Create(rt, TweenInfo.new(.5), {CFrame = DefaultCFrame * CFrame.new(0, 5, 0)}):Play()

    task.wait(.75)

    local ArmModel = script.GiantPistol:Clone()
    local Arm = ArmModel.HumanoidRootPartArm
    ArmModel:PivotTo(unit["Right Arm"].CFrame * CFrame.new(0.0684366226, -0.968129039, 0.220586777, -1.60622221e-07, 1.94813055e-08, 0.999998569, -0.67328763, 0.739384353, 1.22549096e-07, -0.739384532, -0.673286319, 1.0564515e-07) * CFrame.Angles(0, math.rad(90), math.rad(-90)))
    ArmModel.Parent = workspace.Effects
    VFXModule.Debris(ArmModel, 3)
    VFXModule.WeldFunction(unit["Right Arm"], Arm, "ArmWeld")

    SoundWrapper:PlaySound(script.Blast, rt)
    SoundWrapper:PlaySound(script.Dash, rt)

    local NumberValue = Instance.new("NumberValue")
    NumberValue.Value = .01

    TweenService:Create(NumberValue, TweenInfo.new(.65, Enum.EasingStyle.Quad), {Value = 1}):Play()

    local SizeConnection
    SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if NumberValue.Value < 1 then
            ArmModel:ScaleTo(NumberValue.Value)
        end
    end)

    task.wait(.65)
    SoundWrapper:PlaySound(script.Impact, rt)
    
    local Explosion = script.Startup:Clone()
    Explosion.CFrame = rt.CFrame
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)

    local ArmEffect = script.PistolBlast:Clone()
    ArmEffect.CFrame = CFrame.lookAt(Arm.Position, pos.Position) * CFrame.new(0, -4, -17.5) * CFrame.Angles(0, math.rad(-90), math.rad(90))
    ArmEffect.Parent = workspace.Effects
    VFXModule.Debris(ArmEffect, 2)
    VFXModule.Emit(ArmEffect)
    VFXModule.GroundExpandV2(CFrame.new(pos.Position), 14, 12, {baseDestroyWait = 1.5, expandTime = .2})

    local Shockwave = script.Punch:Clone()
    Shockwave.CFrame = CFrame.lookAt(Arm.Position, pos.Position) * CFrame.new(0, -4, -34) * CFrame.Angles(0, math.rad(90), 0)
    Shockwave.Parent = workspace.Effects
    VFXModule.Debris(Shockwave, 1)

    for _, v in pairs(Shockwave:GetDescendants()) do
        if v:IsA("Decal") then
            TweenService:Create(v, TweenInfo.new(.5), {Transparency = 1}):Play()
        end
    end


    TweenService:Create(NumberValue, TweenInfo.new(.35, Enum.EasingStyle.Sine), {Value = 0.0001}):Play()
    TweenService:Create(rt, TweenInfo.new(.5), {CFrame = DefaultCFrame}):Play()

    task.wait(.35)
    VFXModule.EffectToggle(Shockwave, false)
    SizeConnection:Disconnect()

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
