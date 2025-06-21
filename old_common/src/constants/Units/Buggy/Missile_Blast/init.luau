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

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    task.wait(.5)

    for i = 1, 3 do
        local EndPosition = pos.Position + Vector3.new(Rand:NextInteger(-16, 16), 0, Rand:NextInteger(-16, 16))

        task.spawn(function()
            local CannonBall = script.CannonBall:Clone()
            CannonBall.CFrame = CFrame.new(EndPosition + Vector3.new(Rand:NextInteger(-12, 12), Rand:NextInteger(48, 64), Rand:NextInteger(-12, 12)))
            CannonBall.Parent = workspace.Effects
            VFXModule.Debris(CannonBall, 4)

            TweenService:Create(CannonBall, TweenInfo.new(.35), {Size = CannonBall.Size}):Play()
            CannonBall.Size = Vector3.zero
    
            task.wait(1)
            TweenService:Create(CannonBall, TweenInfo.new(.45, Enum.EasingStyle.Quad), {CFrame = CFrame.new(EndPosition)}):Play()
    
            task.wait(.45)

            local Explosion = script.CannonExplosion:Clone()
            Explosion.CFrame = CFrame.new(EndPosition)
            Explosion.Parent = workspace.Effects
            VFXModule.Debris(Explosion, 3)
            VFXModule.Emit(Explosion)
            VFXModule.GroundExpandV2(CFrame.new(pos.Position), 6, 6, {baseDestroyWait = 1.5, expandTime = .2})

            TweenService:Create(CannonBall, TweenInfo.new(.5), {Transparency = 1}):Play()
        end)



        task.wait(.2)
    end
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
