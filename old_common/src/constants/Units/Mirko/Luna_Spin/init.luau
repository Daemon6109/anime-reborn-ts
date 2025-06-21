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
	HitDelay = .25, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

    local TrailBool = true

    task.spawn(function()
		repeat task.wait(.085)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(102, 160, 235)),0.00000000005,.5,"Long",true,5,0,5)
        until not TrailBool
	end)

    task.wait(.5)
	SoundWrapper:PlaySound(script.LunaSpinSound, rt)
    AnimModule.PlayAnim(script.Anim, unit, 1.15, "FireTrail", {Weight = 2, Fade = .15})

    local Spin = script.Spin:Clone()
    Spin.CFrame = rt.CFrame * CFrame.Angles(0, 0, math.rad(-90))
    Spin.Parent = workspace.Effects
    VFXModule.Debris(Spin, 4)
    VFXModule.Emit(Spin)
    VFXModule.EffectToggle(Spin, true)

    VFXModule.WeldFunction(rt, Spin, "SpinTrail")

    task.wait(.25)


    for i = 1, 4 do
        local EndCFrame
        if i == 4 then
            EndCFrame = CFrame.new(pos.Position) * DefaultCFrame.Rotation
        else
            EndCFrame = CFrame.new(DefaultCFrame.Position:Lerp(pos.Position, i / 4) + Vector3.new(Rand:NextInteger(-12, 12), 0, Rand:NextInteger(-12, 12)), pos.Position)
        end

        TweenService:Create(rt, TweenInfo.new(.5), {CFrame = EndCFrame}):Play()

        task.wait(.4)
    end

    TrailBool = false
    VFXModule.EffectToggle(Spin, false)
    AnimModule.StopAnim(unit, "SpinTrail")

    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = pos.CFrame
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(pos.CFrame, 8, 12, {baseDestroyWait = 1.5, expandTime = .2})

    task.wait(.5)
    rt.CFrame = DefaultCFrame


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
