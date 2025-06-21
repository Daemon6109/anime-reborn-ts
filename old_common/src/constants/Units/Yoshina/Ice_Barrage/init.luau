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
    SoundWrapper:PlaySound(script.IceBarrage, rt)

    for i = 1, 6 do
        task.spawn(function()
            local IceSpike = script.IceSpike:Clone()
            IceSpike.CFrame = rt.CFrame * CFrame.new(Rand:NextInteger(-4, 4), Rand:NextInteger(-1, 3), Rand:NextInteger(-4, 4))
            IceSpike.Parent = workspace.Effects
            VFXModule.Debris(IceSpike, 3)
            VFXModule.EffectToggle(IceSpike, true)
        
            task.wait(.65)
        
            local EndCFrame = pos.CFrame * CFrame.new(Rand:NextInteger(-24, 24), -1, Rand:NextInteger(-24, 24))
            TweenService:Create(IceSpike, TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = EndCFrame * IceSpike.CFrame.Rotation}):Play()

            task.wait(.25)

            local Explosion = script.IceExplosion:Clone()
            Explosion.CFrame = EndCFrame
            Explosion.Parent = workspace.Effects
            VFXModule.Debris(Explosion, 3)
            VFXModule.Emit(Explosion)
            VFXModule.GroundExpandV2(EndCFrame, 2, 4, {baseDestroyWait = 1.5, expandTime = .2})
            VFXModule.EffectToggle(IceSpike, false)
        
            task.wait(.1)
        end)
    end
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
