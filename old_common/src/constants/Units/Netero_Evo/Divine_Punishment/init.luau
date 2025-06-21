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

    AnimModule.PlayAnim(script.Anim, unit, 2, "Pose", {Weight = 2, Fade = .15})

    local ArmModel = script.ArmModel:Clone()
    local Arm = ArmModel.PrimaryPart
    ArmModel:PivotTo(CFrame.new(rt.Position) * CFrame.new(0, 2, -10) * CFrame.Angles(0, math.rad(90), math.rad(-8.5)))
    ArmModel.Parent = workspace.Effects
    VFXModule.Debris(ArmModel, 5)
    VFXModule.WeldFunction(rt, Arm, "ArmWeld")

    local NumberValue = Instance.new("NumberValue")
    NumberValue.Value = .01

    TweenService:Create(NumberValue, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Value = 1.5}):Play()

    local SizeConnection
    SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if NumberValue.Value < 1.5 then
            ArmModel:ScaleTo(NumberValue.Value)
        end
    end)

    task.wait(.35)
    NumberValue:Destroy()
	SizeConnection:Disconnect()
	
		AnimModule.PlayAnim(script.ArmAnim, ArmModel, 2, "Pose3", {Weight = 2, Fade = .15})
		--local ArmAnimation = ArmModel.AnimationController:LoadAnimation(script.ArmAnim)
		--ArmAnimation:Play()

    task.wait(.35)
    local Explosion = script.StatueExplosion:Clone()
    Explosion.CFrame = pos.CFrame
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(CFrame.new(pos.Position), 22, 16, {baseDestroyWait = 1.5, expandTime = .2})


    task.wait(.35)

    for _, v in pairs(ArmModel:GetChildren()) do
        if v:IsA("BasePart") then
            print(v)
            TweenService:Create(v, TweenInfo.new(.25), {Transparency = 1}):Play()
        end
    end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
