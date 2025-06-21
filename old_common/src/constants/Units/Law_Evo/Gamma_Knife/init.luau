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
    local Room = RoomModel.Room
    RoomModel:PivotTo(CFrame.new(pos.Position) * CFrame.new(0, -1, 0))
    RoomModel.Parent = workspace.Effects
    VFXModule.Debris(RoomModel, 3)
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
    rt.CFrame = CFrame.new(pos.Position) * DefaultCFrame.Rotation * CFrame.new(0, 12, 20)

    AnimModule.PlayAnim(script.GammaKnifeAnim, unit, 1, "", {Weight = 2, Fade = .15})

    task.spawn(function()
		for i=0,16,1 do
			task.wait(.025)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(0, 255, 94)),0.00000000005,.5,"Mid",true,5,.5,3.6)
		end
	end)

    local Knife = script.Spear:Clone()
    local KnifeSize = Knife.Size
    Knife.Size = Vector3.new(0.1, KnifeSize.Y, 0)
    Knife.CFrame = unit["Left Arm"].CFrame * CFrame.new(0, -1, 0) * CFrame.Angles(0, 0, math.rad(-66.5))
    Knife.Parent = workspace.Effects
    TweenService:Create(Knife, TweenInfo.new(1, Enum.EasingStyle.Quad), {Size = KnifeSize}):Play()
    VFXModule.Debris(Knife, 3)
    VFXModule.Emit(Knife)
    VFXModule.EffectToggle(Knife, true)

    VFXModule.WeldFunction(unit["Right Arm"], Knife, "SpearWeld")
    SoundWrapper:PlaySound(script.Blast, rt)

    task.wait(.5)
    Knife:FindFirstChild("SpearWeld"):Destroy()
    Knife.Anchored = true

    local NumberValue = Instance.new("NumberValue")
    TweenService:Create(NumberValue, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Value = 1}):Play()

    task.spawn(function()
		for i=0,10,1 do
			task.wait(.03)
			emit.bezier(Knife.CFrame,ColorSequence.new(Color3.fromRGB(0, 255, 94)),0.00000000005,.5,"Long",true, 5, 0, 5)
		end
	end)

    local p0 = Knife.Position
    local p2 = pos.Position
    local p1 = p0:Lerp(p2, .375) + Vector3.new(Rand:NextInteger(-24, 24), Rand:NextInteger(4, 16), Rand:NextInteger(-24, 12))

    local MovementConnection
    MovementConnection = RunService.RenderStepped:Connect(function(deltaTime)
        Knife.CFrame = CFrame.lookAt(VFXModule.ReturnQuadraticBezier(NumberValue.Value, p0, p1, p2), VFXModule.ReturnQuadraticBezier(NumberValue.Value + deltaTime, p0, p1, p2))

        if NumberValue.Value == 1 then
            MovementConnection:Disconnect()
            NumberValue:Destroy()
        end
    end)

    SoundWrapper:PlaySound(script.Burst, rt)
    task.wait(.5)

    VFXModule.EffectToggle(Room, false)
    VFXModule.EffectToggle(Knife, false)
    TweenService:Create(Knife, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Size = Vector3.new(0.1, KnifeSize.Y, 0)}):Play()

    local Explosion = script.GammaKnifeExplosion:Clone()
    Explosion.CFrame = CFrame.new(pos.Position) * CFrame.new(0, -1, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Emit(Explosion)
    VFXModule.Debris(Explosion, 3)
    VFXModule.GroundExpandV2(CFrame.new(pos.Position), 16, 12, {baseDestroyWait = 1.5, expandTime = .2})

    task.spawn(function()
		for i=0, 35,1 do
			task.wait(.03)
			emit.bezier(Explosion.CFrame * CFrame.new(Rand:NextInteger(-36, 36), Rand:NextInteger(2, 24), Rand:NextInteger(-36, 36)) ,ColorSequence.new(Color3.fromRGB(0, 255, 94)),0.00000000005,.5,"Long",true, 5, 0, 5)
		end
	end)

    task.wait(1)
    rt.CFrame = DefaultCFrame


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
