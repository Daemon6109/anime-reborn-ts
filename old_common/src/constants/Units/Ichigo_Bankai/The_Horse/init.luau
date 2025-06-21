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
	HitDelay = 1.25, -- seconds
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

    AnimModule.PlayAnim(script.SwordThrow, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
    task.wait(.5)

    local Sword = script.Sword:Clone()
    Sword.CFrame = unit["Left Arm"].CFrame * CFrame.new(0, -1, 0) * CFrame.Angles(0, 0, math.rad(-66.5))
    Sword.Parent = workspace.Effects
    VFXModule.Debris(Sword, 3)
    VFXModule.Emit(Sword)
    VFXModule.EffectToggle(Sword, true)

    local NumberValue = Instance.new("NumberValue")
    TweenService:Create(NumberValue, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Value = 1}):Play()

    local p0 = Sword.Position
    local p2 = pos.Position
    local p1 = p0:Lerp(p2, .375) + Vector3.new(Rand:NextInteger(-24, 24), Rand:NextInteger(4, 16), Rand:NextInteger(-24, 12))

    local MovementConnection
    MovementConnection = RunService.RenderStepped:Connect(function(deltaTime)
        Sword.CFrame = CFrame.lookAt(VFXModule.ReturnQuadraticBezier(NumberValue.Value, p0, p1, p2), VFXModule.ReturnQuadraticBezier(NumberValue.Value + deltaTime, p0, p1, p2)) * CFrame.Angles(0, math.rad((720 * deltaTime)), 0)

        if NumberValue.Value == 1 then
            MovementConnection:Disconnect()
            NumberValue:Destroy()
        end
    end)

    task.wait(.5)
    rt.CFrame = CFrame.new(pos.Position + Vector3.new(0, 0, 2)) * rt.CFrame.Rotation

    VFXModule.EffectToggle(Sword, false)

    task.wait(.25)

    TweenService:Create(Sword.Sword, TweenInfo.new(.35), {Transparency = 1}):Play()

    local Explosion = script.IchigoExplosion:Clone()
    Explosion.CFrame = CFrame.new(pos.Position) * CFrame.new(0, -1, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Emit(Explosion)
    VFXModule.Debris(Explosion, 3)
    VFXModule.GroundExpandV2(rt.CFrame, 12, 12, {baseDestroyWait = 2})

    task.wait(.75)

    rt.CFrame = DefaultCFrame
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
