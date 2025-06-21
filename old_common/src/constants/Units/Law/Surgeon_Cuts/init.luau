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
    RoomModel:PivotTo(CFrame.new(rt.Position))
    RoomModel.Parent = workspace.Effects
    VFXModule.Debris(RoomModel, 5)
    VFXModule.EffectToggle(Room, true)

    SoundWrapper:PlaySound(script.Room, rt)

    local NumberValue = Instance.new("NumberValue")
    NumberValue.Value = .01

    TweenService:Create(NumberValue, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Value = 0.5}):Play()

    local SizeConnection
    SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if NumberValue.Value < 0.5 then
            RoomModel:ScaleTo(NumberValue.Value)
        end
    end)

    task.wait(.5)
    SizeConnection:Disconnect()

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    local Slash = script.Slash:Clone()
    Slash.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0) * CFrame.Angles(math.rad(math.random(-10, 10)), math.rad(math.random(-30, 30)), math.rad(math.random(-10, 10)))
    Slash.Parent = workspace.Effects
    VFXModule.Debris(Slash, 2)

    task.spawn(function()
        VFXModule.Emit(Slash, 5, .3)
    end)

    task.wait(.5)

    task.spawn(function()
		for i=0,10,1 do
			task.wait(.03)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(0, 255, 94)),0.00000000005,.5,"Long",true, 5, 0, 5)
		end
	end)


    task.wait(.5)


    for i = 1, 5 do
		local Explosion = script.LightningDrop:Clone()
		Explosion:PivotTo(CFrame.new(rt.Position) * CFrame.new(Rand:NextInteger(-20, 20), 0, -20 - (Rand:NextInteger(0, 20))))
        --Explosion.CFrame = CFrame.new(rt.Position) * CFrame.new(Rand:NextInteger(-20, 20), 0, -20 - (Rand:NextInteger(0, 20)))
        Explosion.Parent = workspace.Effects
        VFXModule.Emit(Explosion)
        VFXModule.Debris(Explosion, 3)
        VFXModule.GroundExpandV2(CFrame.new(Explosion.Position), 6, 6, {baseDestroyWait = 1.5, expandTime = .2})

        task.spawn(function()
            for _ =0, 2,1 do
                task.wait(.03)
                emit.bezier(Explosion.CFrame * CFrame.new(Rand:NextInteger(-36, 36), Rand:NextInteger(2, 24), Rand:NextInteger(-36, 36)) ,ColorSequence.new(Color3.fromRGB(0, 255, 94)),0.00000000005,.5,"Long",true, 5, 0, 5)
            end
        end)
        
        task.wait(.35)
    end

    VFXModule.EffectToggle(Room, false)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
