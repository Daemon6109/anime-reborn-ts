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

    for i = 1, 2 do
        task.spawn(function()
            local ArmModel = script.Arm:Clone()
            if i == 1 then
                ArmModel:PivotTo(pos.CFrame * CFrame.new(8, 4, 0) * CFrame.Angles(0, math.rad(180), 0))
            else
                ArmModel:PivotTo(pos.CFrame * CFrame.new(-8, 4, 0) * CFrame.Angles(0, math.rad(180), 0))
            end

            ArmModel.Parent = workspace.CurrentCamera
            VFXModule.Debris(ArmModel, 1.15)
            VFXModule.EffectToggle(ArmModel, true)

            local NumberValue = Instance.new("NumberValue")
            NumberValue.Value = .1
    
            TweenService:Create(NumberValue, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Value = 6}):Play()
    
            local SizeConnection
            SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
                if NumberValue.Value < 6 then
                    ArmModel:ScaleTo(NumberValue.Value)
                else
                    SizeConnection:Disconnect()
                end
            end)
            
            task.wait(.5)
            SoundWrapper:PlaySound(script.ArmMove, rt)

            AnimModule.PlayAnim(script.ArmAnimation, ArmModel, 1, "", {Weight = 2, Fade = .15})

            task.wait(.3)
            
            -- TweenService:Create(Fish, TweenInfo.new(.35), {Transparency = 1}):Play()
            -- VFXModule.EffectToggle(Fish, false)

            local Explosion = script.FlowerExplosion:Clone()
            if i == 1 then
                Explosion.CFrame = pos.CFrame * CFrame.new(8, 1, 0)
            else
                Explosion.CFrame = pos.CFrame * CFrame.new(-8, 1, 0)
            end
            Explosion.Parent = workspace.Effects
            VFXModule.Debris(Explosion, 3)
            VFXModule.Emit(Explosion)
            VFXModule.GroundExpandV2(Explosion.CFrame, 8, 8, {baseDestroyWait = 1.5, expandTime = .2})
        end)
    
    end

    task.wait(.85)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
