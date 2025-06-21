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

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    TweenService:Create(rt, TweenInfo.new(.5), {CFrame = CFrame.new((CFrame.new(pos.Position) * CFrame.new(0, 10, 4)).Position, pos.Position)}):Play()

    task.wait(.5)

    for i = 1, 6 do
        task.spawn(function()
            local Rock = script.Card:Clone()
            Rock.CFrame = rt.CFrame * CFrame.new(Rand:NextInteger(-6, 6), Rand:NextInteger(2, 4), Rand:NextInteger(-3, 3)) * CFrame.Angles(math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360)))
            Rock.Parent = workspace.Effects
            VFXModule.Debris(Rock, 3)
            TweenService:Create(Rock, TweenInfo.new(.65, Enum.EasingStyle.Quad), {Size = Rock.Size * 2.5, CFrame = Rock.CFrame * CFrame.new(0, 8, 0)}):Play()
            Rock.Size = Vector3.zero
        
            task.wait(.65)
        
            local EndCFrame = pos.CFrame * CFrame.new(Rand:NextInteger(-24, 24), -1, Rand:NextInteger(-24, 24))
            TweenService:Create(Rock, TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = EndCFrame * Rock.CFrame.Rotation}):Play()

            task.wait(.25)

            local Explosion = script.CardSlice:Clone()
            Explosion.CFrame = EndCFrame
            Explosion.Parent = workspace.Effects
            VFXModule.Debris(Explosion, 3)
            VFXModule.Emit(Explosion)
            VFXModule.GroundExpandV2(EndCFrame, 2, 4, {baseDestroyWait = 1.5, expandTime = .2})
            TweenService:Create(Rock, TweenInfo.new(.35), {Transparency = 1, CFrame = Rock.CFrame * CFrame.new(0, -10, 0)}):Play()
            VFXModule.EffectToggle(Rock, false)

            task.wait(.1)
        end)
    end

    task.wait(1)
    rt.CFrame = DefaultCFrame

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
