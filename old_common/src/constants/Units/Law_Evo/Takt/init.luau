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

    local RoomModel = script.RoomModel:Clone()
    local Room = RoomModel:GetChildren()[1]
    RoomModel:PivotTo(CFrame.new(pos.Position))
    RoomModel.Parent = workspace.Effects
    VFXModule.Debris(RoomModel, 5)
    VFXModule.EffectToggle(Room, true)

    SoundWrapper:PlaySound(script.Room, rt)

    local NumberValue = Instance.new("NumberValue")
    NumberValue.Value = .01

    TweenService:Create(NumberValue, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Value = 0.5}):Play()

    local SizeConnection
    SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if NumberValue.Value < 1 then
            RoomModel:ScaleTo(NumberValue.Value)
        end
    end)

    task.wait(.5)
    SizeConnection:Disconnect()

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    VFXModule.GroundExpandV2(CFrame.new(pos.Position), 20, 25, {baseDestroyWait = 1.5, expandTime = .2})

    local Explosion = script.RockImpact:Clone()
    Explosion.CFrame = CFrame.new(pos.Position)
    Explosion.Parent = workspace.Effects
    VFXModule.Emit(Explosion)
    VFXModule.Debris(Explosion, 3)
    VFXModule.GroundExpandV2(CFrame.new(Explosion.Position), 6, 8, {baseDestroyWait = 1.5, expandTime = .2})

    task.wait(.5)

    local Rock = script.Rock:Clone()
    Rock.CFrame = pos.CFrame * CFrame.new(0, 20, 0) * CFrame.Angles(math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360)))
    Rock.Parent = workspace.Effects
    VFXModule.Debris(Rock, 3)
    TweenService:Create(Rock, TweenInfo.new(.65, Enum.EasingStyle.Quad), {Size = Rock.Size * 5, CFrame = Rock.CFrame * CFrame.new(0, 8, 0)}):Play()

    task.wait(.65)

    TweenService:Create(Rock, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = pos.CFrame}):Play()

    task.wait(.125)
    local BigExplosion = script.Explosion:Clone()
    BigExplosion.CFrame = CFrame.new(pos.Position)
    BigExplosion.Parent = workspace.Effects
    VFXModule.Emit(BigExplosion)
    VFXModule.Debris(BigExplosion, 3)
    VFXModule.GroundExpandV2(CFrame.new(BigExplosion.Position), 16, 12, {baseDestroyWait = 1.5, expandTime = .2})
    TweenService:Create(Rock, TweenInfo.new(.25, Enum.EasingStyle.Quad), {Size = Vector3.zero}):Play()

    task.wait(.5)

    VFXModule.EffectToggle(Room, false)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
