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
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})
    SoundWrapper:PlaySound(script.KiBlasts, rt)    

    for i = 1, 8 do
        task.spawn(function()
            local StringValue = "1" if i % 2 ~= 0 then StringValue = "1" else StringValue = 2 end
            local FishModel = script["Ball"..StringValue]:Clone()
            local Fish = FishModel.Ball
            FishModel:PivotTo(rt.CFrame * CFrame.new(Rand:NextInteger(-4, 4), Rand:NextInteger(-.5, 2), Rand:NextInteger(-2, 2)))
            FishModel.Parent = workspace.Effects
            VFXModule.Debris(FishModel, 1.15)
            VFXModule.EffectToggle(Fish, true)
        
            local p0, p1, p2 = Fish.Position, Fish.Position:Lerp(pos.Position, .5) + Vector3.new(Rand:NextInteger(-12, 12), 0, Rand:NextInteger(0, -12)), pos.Position + Vector3.new(Rand:NextInteger(-12, 12), -1, Rand:NextInteger(-12, 12))

            local NumberValue = Instance.new("NumberValue")
            NumberValue.Value = .1
    
            TweenService:Create(NumberValue, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Value = .25}):Play()
    
            local SizeConnection
            SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
                if NumberValue.Value < .25 then
                    FishModel:ScaleTo(NumberValue.Value)
                else
                    SizeConnection:Disconnect()
                end
            end)
        
            task.wait(.35)
        
            local connection
            local ElapsedTime = 0
            connection = RunService.Heartbeat:Connect(function(deltaTime)
                ElapsedTime += deltaTime
                local t = TweenService:GetValue(ElapsedTime/.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                FishModel:PivotTo(CFrame.lookAt(VFXModule.ReturnQuadraticBezier(t, p0, p1, p2), VFXModule.ReturnQuadraticBezier(t + deltaTime, p0, p1, p2)) * CFrame.Angles(math.rad(90), 0, 0))
            end)
        
            local trailBool
        
            task.spawn(function()
                repeat
                    emit.bezier(Fish.CFrame,ColorSequence.new(Color3.fromRGB(255, 255, 255)),0.00000000005,.5,"Long",true,5,0,5)
                    task.wait(.045 * 5)
                until trailBool == false
            end)
        
            task.wait(.5)
            TweenService:Create(Fish, TweenInfo.new(.35), {Transparency = 1}):Play()
            connection:Disconnect()
            trailBool = false
            VFXModule.EffectToggle(Fish, false)

            local Explosion = script["Explosion"..StringValue]:Clone()
            Explosion.CFrame = Fish.CFrame
            Explosion.Parent = workspace.Effects
            VFXModule.Debris(Explosion, 3)
            VFXModule.Emit(Explosion)
            VFXModule.GroundExpandV2(CFrame.new(Fish.Position), 4, 6, {baseDestroyWait = 1.5, expandTime = .2})
        end)

        task.wait(.1)
    end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
