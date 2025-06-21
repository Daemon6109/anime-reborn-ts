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
	HitDelay = .35, -- seconds
	HitCount = 12, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .085, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

    AnimModule.PlayAnim(script.Anim, unit, 1.2, "", {Weight = 2, Fade = .15})
    SoundWrapper:PlaySound(script.IceSpike, rt)

    for i = 1, 3 do
        task.spawn(function()
            local EndCFrame, Scale
                if i == 1 then
                    EndCFrame = rt.CFrame * CFrame.new(0, -2, -5) * CFrame.Angles(math.rad(90), 0, 0)
                    Scale = 1
                elseif i == 2 then
                    EndCFrame = rt.CFrame * CFrame.new(0, -2, -11) * CFrame.Angles(math.rad(90), 0, 0)
                    Scale = 1.35
                else
                    EndCFrame = rt.CFrame * CFrame.new(0, -2, -18) * CFrame.Angles(math.rad(90), 0, 0)
                    Scale = 1.6
                end

                local IceSpikes = script.IceSpikes:Clone()
                local Spikes = IceSpikes.Spikes
                IceSpikes:PivotTo(EndCFrame)
                IceSpikes.Parent = workspace.Effects
                VFXModule.Debris(IceSpikes, 3)
                VFXModule.Emit(Spikes)
            
                local NumberValue = Instance.new("NumberValue")
                NumberValue.Value = .1
        
                TweenService:Create(NumberValue, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Value = Scale}):Play()
        
                local SizeConnection
                SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
                    if NumberValue.Value < Scale then
                        IceSpikes:ScaleTo(NumberValue.Value)
                    else
                        SizeConnection:Disconnect()
                    end
                end)
            
                task.wait(.35)
                VFXModule.Emit(Spikes)
            
                local trailBool
            
                task.spawn(function()
                    repeat
                        emit.bezier(Spikes.CFrame,ColorSequence.new(Color3.fromRGB(69, 143, 255)),0.00000000005,.5,"Long",true,5,0,5)
                        task.wait(.045 * 5)
                    until trailBool == false
                end)
            
                task.wait(.5)
                trailBool = false
                task.wait(1)
                TweenService:Create(Spikes, TweenInfo.new(.35, Enum.EasingStyle.Cubic), {Transparency = 1}):Play()
        end)
    end
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
