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
	HitDelay = .6, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Anim, unit, 1.5, "", {Weight = 2, Fade = .15})

    task.wait(.65)
    rt.CFrame = CFrame.new(pos.Position) * DefaultCFrame.Rotation * CFrame.new(0, 0, 6)

    for i = 1, 4 do
        local Slash = script.Slash:Clone()
        Slash.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0) * CFrame.Angles(math.rad(math.random(-10, 10)), math.rad(math.random(-30, 30)), math.rad(math.random(-10, 10)))
        Slash.Parent = workspace.Effects
        VFXModule.Emit(Slash)

        task.wait(.3)
    end


    task.wait(.2)
    
    local Explosion = script.PipeSmash:Clone()
    Explosion.CFrame = pos.CFrame * CFrame.new(0, 5, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(pos.CFrame, 8, 12, {baseDestroyWait = 1.5, expandTime = .2})

    for _, v in pairs(Explosion:GetDescendants()) do
        if v:IsA("Decal") then
            TweenService:Create(v, TweenInfo.new(2), {Transparency = 1}):Play()
        end
    end

    task.wait(1)
    rt.CFrame = DefaultCFrame
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
