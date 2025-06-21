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
	HitDelay = .85, -- seconds
	HitCount = 8, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1875, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Anim, unit, 1.85, "", {Weight = 2, Fade = .15})
    SoundWrapper:PlaySound(script.RavagingOrbs, rt)    


    local Fireball = script.Ball:Clone()
    Fireball.CFrame = unit["Right Arm"].CFrame * CFrame.new(0, -1.5, 0)
    Fireball.Parent = workspace.Effects
    VFXModule.Debris(Fireball, 3)
    VFXModule.EffectToggle(Fireball, true)
    VFXModule.WeldFunction(unit["Right Arm"], Fireball, "FireballWeld")

    task.wait(.85)
    local connection

    task.delay(.2, function()
        for i = 1, 4 do
            task.spawn(function()
                local Ball = script.Trail:Clone()
                Ball.CFrame = rt.CFrame * CFrame.new(Rand:NextInteger(-4, 4), Rand:NextInteger(-1, 2), Rand:NextInteger(-1, 1))
                Ball.Parent = workspace.Effects
                VFXModule.Debris(Ball, 3)
                VFXModule.Emit(Ball)
    
                task.delay(1.5, function()
                    VFXModule.EffectToggle(Ball, false)
                end)
        
                local p0, p1, p2 = Ball.Position, Ball.Position:Lerp(pos.Position, .5) + Vector3.new(Rand:NextInteger(-12, 12), 0, Rand:NextInteger(0, -12)), pos.Position + Vector3.new(Rand:NextInteger(-12, 12), -1, Rand:NextInteger(-12, 12))
        
                local NumberValue = Instance.new("NumberValue")
                NumberValue.Value = .1
        
                TweenService:Create(NumberValue, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Value = .25}):Play()
            
                task.wait(.35)
            
                local ElapsedTime = 0
                connection = RunService.Heartbeat:Connect(function(deltaTime)
                    ElapsedTime += deltaTime
                    local t = TweenService:GetValue(ElapsedTime/.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    Ball.CFrame = CFrame.lookAt(VFXModule.ReturnQuadraticBezier(t, p0, p1, p2), VFXModule.ReturnQuadraticBezier(t + deltaTime, p0, p1, p2))
                end)
            end)
            task.wait(.1)
        end
    end)

    Fireball.FireballWeld:Destroy()
    TweenService:Create(Fireball, TweenInfo.new(.5, Enum.EasingStyle.Quad), {CFrame = CFrame.new(pos.Position) * Fireball.CFrame.Rotation}):Play()

    task.wait(.5)
    
    VFXModule.EffectToggle(Fireball, false)
    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = pos.CFrame * CFrame.new(0, 8, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(pos.CFrame, 12, 12, {baseDestroyWait = 1.5, expandTime = .2})

    task.wait(1)
    rt.CFrame = DefaultCFrame
    connection:Disconnect()
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
