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
	HitDelay = .7, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.TornadoBlitz, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

    task.wait(.65)

    for i = 1, 3 do
        task.spawn(function()
            local Tornado = script.Tornado:Clone()
            if i == 1 then
                Tornado.CFrame = rt.CFrame * CFrame.new(0, 0, -3) * CFrame.Angles(0, math.rad(180), 0) elseif i == 2 then Tornado.CFrame = rt.CFrame * CFrame.new(6, 0, -2) * CFrame.Angles(0, math.rad(180), 0) else Tornado.CFrame = rt.CFrame * CFrame.new(-6, 0, -2) * CFrame.Angles(0, math.rad(180), 0)
            end
            Tornado.Parent = workspace.Effects
            VFXModule.EffectToggle(Tornado, true)
            VFXModule.Debris(Tornado, 4)
    
            task.spawn(function()
                for _ = 0,16,1 do
                    task.wait(.025)
                    emit.bezier(Tornado.CFrame,ColorSequence.new(Color3.fromRGB(102, 102, 102)),0.00000000005, 4,"Mid",true,5,.65,5)
                end
            end)
        
            local EndCFrame
            if i == 1 then
                EndCFrame = CFrame.new(pos.Position) * Tornado.CFrame.Rotation
            elseif i == 2 then
                EndCFrame = CFrame.new(pos.Position) * Tornado.CFrame.Rotation * CFrame.new(16, 0, 0)
            else
                EndCFrame = CFrame.new(pos.Position) * Tornado.CFrame.Rotation * CFrame.new(-16, 0, 0)
            end
    
            TweenService:Create(Tornado, TweenInfo.new(1, Enum.EasingStyle.Quad), {CFrame = EndCFrame}):Play()
            task.wait(1.5)
            VFXModule.EffectToggle(Tornado, false)
        end)
        task.wait(.2)
    end



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
