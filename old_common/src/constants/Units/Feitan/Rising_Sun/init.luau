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
	HitCount = 12, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .3, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    local DeathBallModel = script.Sun:Clone()
    local DeathBall = DeathBallModel.Sun
    DeathBallModel:PivotTo(rt.CFrame * CFrame.new(0, 20, -2))
    DeathBallModel.Parent = workspace.Effects
    VFXModule.Debris(DeathBallModel, 4)     
    VFXModule.EffectToggle(DeathBall, true)

    local Charge = script.SunChargeup:Clone()
    Charge.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0)
    Charge.Parent = workspace.Effects
    VFXModule.EffectToggle(Charge, true)
    VFXModule.Debris(Charge, 4)

    local NumberValue = Instance.new("NumberValue")
    NumberValue.Value = .01
    TweenService:Create(NumberValue, TweenInfo.new(1), {Value = 1}):Play()

    local connection

    connection = RunService.Heartbeat:Connect(function(deltaTime)
        DeathBallModel:ScaleTo(NumberValue.Value)
    end)

    local trailBool
    task.spawn(function()
		repeat task.wait(.025)
			task.wait(.025)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 112, 69)),0.00000000005,.5,"Long",true,5,0,5)
        until not trailBool
	end)
    task.wait(.75)
    VFXModule.EffectToggle(Charge, false)

    TweenService:Create(DeathBall, TweenInfo.new(.5), {CFrame = CFrame.new(pos.Position)}):Play()

    task.wait(.5)
    trailBool = false
    connection:Disconnect()
    VFXModule.EffectToggle(DeathBall, false)
    task.spawn(function()
		repeat task.wait(.025)
			task.wait(.025)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 112, 69)),0.00000000005,.5,"Long",true,5,0, 8)
        until not trailBool
	end)

    trailBool = false

    local HeatModel = script.SunModel:Clone()
    local Heat = HeatModel.SunExplosion
    HeatModel:PivotTo(pos.CFrame * CFrame.new(0, -2, 0))
    HeatModel.Parent = workspace.CurrentCamera
    VFXModule.Debris(HeatModel, 8)
    VFXModule.Emit(Heat)

    VFXModule.GroundExpandV2(pos.CFrame, 24, 12, {baseDestroyWait = 1.5})

    for _, v in pairs(Heat:GetDescendants()) do
        if v:IsA("Attachment") then
            local vPosition = v.Position
            v.Position = Vector3.zero
            TweenService:Create(v, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Position = vPosition}):Play()
        end
    end

    VFXModule.EffectToggle(Heat, true)

    task.delay(.75 * 2, function()
        VFXModule.Emit(Heat, 2, .3)
        VFXModule.GroundExpandV2(pos.CFrame, 30, 16, {baseDestroyWait = 1.5})
    end)

    task.wait(1.5 * 1.35 + 1)

    for _, v in pairs(Heat:GetDescendants()) do
        if v:IsA("Beam") then
            TweenService:Create(v, TweenInfo.new(.5), {Width0 = 0, Width1 = 0}):Play()
        end
    end

    trailBool = false
    VFXModule.EffectToggle(HeatModel, false, true)

    for _, v in pairs(HeatModel:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = true
            TweenService:Create(v, TweenInfo.new(.5), {Transparency = 1}):Play()
        end
    end

    task.spawn(function()
		for i=0, 35,1 do
			task.wait(.03)
			emit.bezier(Heat.CFrame * CFrame.new(Rand:NextInteger(-48, 48), Rand:NextInteger(24, 48), Rand:NextInteger(-48, 48)) ,ColorSequence.new(Color3.fromRGB(255, 112, 69)),0.00000000005,.5,"Long",true, 5, 0, 8)
		end
	end)

    VFXModule.Emit(Heat)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
