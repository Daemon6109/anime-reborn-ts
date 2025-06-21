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

    AnimModule.PlayAnim(script.WolfRampage, unit, 1, "", {Weight = 2, Fade = .15})

    for i = 1, 6 do
        task.spawn(function()
            local WolfModel = script.Wolf:Clone()
            local Wolf = WolfModel.Wolf
            WolfModel:PivotTo(rt.CFrame * CFrame.new(Rand:NextInteger(-12, 12), -.35, Rand:NextInteger(-8, 8)) * CFrame.Angles(0, math.rad(180), 0))
            WolfModel.Parent = workspace.Effects
            VFXModule.Debris(WolfModel, 1.15)
            VFXModule.EffectToggle(Wolf, true)
        
            local p0, p1, p2 = Wolf.Position, Wolf.Position:Lerp(pos.Position, .5) + Vector3.new(Rand:NextInteger(-12, 12), 0, Rand:NextInteger(0, -12)), pos.Position

            local NumberValue = Instance.new("NumberValue")
            NumberValue.Value = .1
    
            TweenService:Create(NumberValue, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Value = 1}):Play()
    
            local SizeConnection
            SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
                if NumberValue.Value < 1 then
                    WolfModel:ScaleTo(NumberValue.Value)
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
                WolfModel:PivotTo(CFrame.lookAt(VFXModule.ReturnQuadraticBezier(t, p0, p1, p2), VFXModule.ReturnQuadraticBezier(t + deltaTime, p0, p1, p2)) * CFrame.Angles(0, math.rad(180), 0))
            end)
        
            local trailBool
        
            task.spawn(function()
                repeat
                    emit.bezier(Wolf.CFrame,ColorSequence.new(Color3.fromRGB(69, 143, 255)),0.00000000005,.5,"Long",true,5,0,5)
                    task.wait(.045 * 5)
                until trailBool == false
            end)
        
            task.wait(.5)
            connection:Disconnect()
            trailBool = false
            VFXModule.EffectToggle(Wolf, false)
        end)
    
    end

    task.wait(.85)

    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = pos.CFrame
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(CFrame.new(pos.Position), 16, 12, {baseDestroyWait = 1.5, expandTime = .2})


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
