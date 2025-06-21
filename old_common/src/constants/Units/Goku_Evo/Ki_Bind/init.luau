local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local TweenService = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local VFXModule = require(Replicated.Libs.VFXModule)

module.config = {
	HitDelay = 1.45, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})
    SoundWrapper:PlaySound(script.KiBind, rt)    

    for i = 1, 4 do
        local Angle = math.rad((360/4) * i)
        local Ball = script.Ball:Clone()
        Ball.CFrame = pos.CFrame * CFrame.new(math.sin(Angle) * 12, 2, math.cos(Angle) * 12)
        Ball.Parent = workspace.Effects
        VFXModule.Debris(Ball, 3)
        VFXModule.EffectToggle(Ball, true)

        task.delay(1.5, function()
            VFXModule.EffectToggle(Ball, false)
        end)

        task.wait(.3)
    end

    task.wait(.25)

    local Beam = script.Beam:Clone()
    Beam.CFrame = pos.CFrame * CFrame.new(0, 12, 0) * CFrame.Angles(0, math.rad(180), math.rad(90))
    Beam.Parent = workspace.Effects
    VFXModule.Debris(Beam, 2)
    VFXModule.Emit(Beam)
    VFXModule.GroundExpandV2(pos.CFrame, 12, 12, {baseDestroyWait = 1.5, expandTime = .2})

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
