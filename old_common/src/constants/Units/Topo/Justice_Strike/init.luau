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
	HitDelay = 1.25, -- seconds
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

    task.wait(.75)

    for i = 1, 5 do
        task.spawn(function()
            local Fireball = script.Ball:Clone()
            Fireball.CFrame = unit["Right Arm"].CFrame * CFrame.new(0, -1.5, 0)
            Fireball.Parent = workspace.Effects
            VFXModule.Debris(Fireball, 3)
            VFXModule.EffectToggle(Fireball, true)
            VFXModule.WeldFunction(unit["Right Arm"], Fireball, "FireballWeld")
        
            task.wait(.35)
            Fireball.FireballWeld:Destroy()
            Fireball.Anchored = true
            TweenService:Create(Fireball, TweenInfo.new(.5, Enum.EasingStyle.Quad), {CFrame = CFrame.new(pos.Position) * Fireball.CFrame.Rotation}):Play()

            task.wait(1)
            VFXModule.EffectToggle(Fireball, false)
        end)
        task.wait(.35)
    end

    task.wait(.5)
    
    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = pos.CFrame * CFrame.new(0, 4, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(pos.CFrame, 12, 12, {baseDestroyWait = 1.5, expandTime = .2})
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
