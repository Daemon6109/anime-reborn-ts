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
	HitDelay = 1.2, -- seconds
	HitCount = 12, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .125, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

    AnimModule.PlayAnim(script.EnergyBarrier, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
    task.spawn(function()
		for i=0,16,1 do
			task.wait(.025)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 221, 69)),0.00000000005,.5,"Mid",true,5,.2,3.6)
		end
	end)

    task.wait(.35)

    local Triangle = script.Triangle:Clone()
    local OrihimeTriangle = Triangle.OrihimeTriangle
    Triangle:PivotTo(pos.CFrame)
    Triangle.Parent = workspace.Effects
    VFXModule.Debris(Triangle, 4)
    VFXModule.EffectToggle(OrihimeTriangle, true)

    local NumberValue = Instance.new("NumberValue")
    NumberValue.Value = .1

    TweenService:Create(NumberValue, TweenInfo.new(1, Enum.EasingStyle.Quad), {Value = 1}):Play()

    local SizeConnection
    SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if NumberValue.Value < 1 then
            Triangle:ScaleTo(NumberValue.Value)
        end
    end)

    task.wait(1)

    local Burst = script.Burst:Clone()
    Burst.CFrame = CFrame.new(pos.Position) * CFrame.new(0, -1, 0)
    Burst.Parent = workspace.Effects
    VFXModule.Emit(Burst)
    VFXModule.Debris(Burst, 3)

    task.spawn(function()
		for i=0, 35,1 do
			task.wait(.03)
			emit.bezier(Burst.CFrame * CFrame.new(Rand:NextInteger(-24, 24), Rand:NextInteger(2, 16), Rand:NextInteger(-24, 24)) ,ColorSequence.new(Color3.fromRGB(255, 221, 69)),0.00000000005,.5,"Long",true, 5, 0, 5)
		end
	end)

    task.wait(1.5)

    VFXModule.EffectToggle(Triangle, false)
    TweenService:Create(NumberValue, TweenInfo.new(.5, Enum.EasingStyle.Quad), {Value = .01}):Play()
    task.wait(.5)
    SizeConnection:Disconnect()


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
