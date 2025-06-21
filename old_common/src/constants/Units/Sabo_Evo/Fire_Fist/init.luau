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

    task.wait(1)

    local Fireball = script.Fireball:Clone()
    Fireball.CFrame = rt.CFrame * CFrame.new(0, 1.5, -1) * CFrame.Angles(0, math.rad(180), 0)
    Fireball.Parent = workspace.Effects
    VFXModule.Debris(Fireball, 3)
    VFXModule.EffectToggle(Fireball, true)

    TweenService:Create(Fireball, TweenInfo.new(.75, Enum.EasingStyle.Quad), {CFrame = CFrame.new(pos.Position) * Fireball.CFrame.Rotation}):Play()

    task.wait(.75)
    
    VFXModule.EffectToggle(Fireball, false)
    local Explosion = script.FireEruption:Clone()
    Explosion.CFrame = pos.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(0, math.rad(180), 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(pos.CFrame, 8, 12, {baseDestroyWait = 1.5, expandTime = .2})

    for _, v in pairs(Explosion:GetDescendants()) do
        if v:IsA("Decal") then
            TweenService:Create(v, TweenInfo.new(2), {Transparency = 1}):Play()
        end
    end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
