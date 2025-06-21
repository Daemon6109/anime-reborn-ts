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

    AnimModule.PlayAnim(script.SpearAnim, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
    task.spawn(function()
		for i=0,16,1 do
			task.wait(.025)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(0, 255, 94)),0.00000000005,.5,"Mid",true,5,.5,3.6)
		end
	end)

    local Spear = script.Spear:Clone()
    local SpearSize = Spear.Size
    Spear.Size = Vector3.new(0.1, SpearSize.Y, 0)
    Spear.CFrame = unit["Left Arm"].CFrame * CFrame.new(0, -1, 0) * CFrame.Angles(0, 0, math.rad(-66.5))
    Spear.Parent = workspace.Effects
    TweenService:Create(Spear, TweenInfo.new(1, Enum.EasingStyle.Quad), {Size = SpearSize}):Play()
    VFXModule.Debris(Spear, 3)
    VFXModule.Emit(Spear)
    VFXModule.EffectToggle(Spear, true)

    VFXModule.WeldFunction(unit["Left Arm"], Spear, "SpearWeld")


    task.wait(.5)
    Spear:FindFirstChild("SpearWeld"):Destroy()
    Spear.Anchored = true

    local NumberValue = Instance.new("NumberValue")
    TweenService:Create(NumberValue, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Value = 1}):Play()

    task.spawn(function()
		for i=0,10,1 do
			task.wait(.03)
			emit.bezier(Spear.CFrame,ColorSequence.new(Color3.fromRGB(0, 255, 94)),0.00000000005,.5,"Long",true, 5, 0, 5)
		end
	end)

    local p0 = Spear.Position
    local p2 = pos.Position
    local p1 = p0:Lerp(p2, .375) + Vector3.new(Rand:NextInteger(-24, 24), Rand:NextInteger(4, 16), Rand:NextInteger(-24, 12))

    local MovementConnection
    MovementConnection = RunService.RenderStepped:Connect(function(deltaTime)
        Spear.CFrame = CFrame.lookAt(VFXModule.ReturnQuadraticBezier(NumberValue.Value, p0, p1, p2), VFXModule.ReturnQuadraticBezier(NumberValue.Value + deltaTime, p0, p1, p2))

        if NumberValue.Value == 1 then
            MovementConnection:Disconnect()
            NumberValue:Destroy()
        end
    end)

    task.wait(.5)

    VFXModule.EffectToggle(Spear, false)
    TweenService:Create(Spear, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Size = Vector3.new(0.1, SpearSize.Y, 0)}):Play()

    local Explosion = script.SpearExplosion:Clone()
    Explosion.CFrame = CFrame.new(pos.Position) * CFrame.new(0, -1, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Emit(Explosion)
    VFXModule.Debris(Explosion, 3)

    task.spawn(function()
		for i=0, 35,1 do
			task.wait(.03)
			emit.bezier(Explosion.CFrame * CFrame.new(Rand:NextInteger(-36, 36), Rand:NextInteger(2, 24), Rand:NextInteger(-36, 36)) ,ColorSequence.new(Color3.fromRGB(0, 255, 94)),0.00000000005,.5,"Long",true, 5, 0, 5)
		end
	end)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
