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
	HitDelay = .35, -- seconds
	HitCount = 8, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1875, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Anim, unit, 1.5, "", {Weight = 2, Fade = .15})
    SoundWrapper:PlaySound(script.JirenBarrage, rt)    

    TweenService:Create(rt, TweenInfo.new(.35, Enum.EasingStyle.Quad), {CFrame = CFrame.new(pos.Position) * DefaultCFrame.Rotation * CFrame.new(0, 0, 2)}):Play()

    task.wait(.35)

    for i = 1, 12 do
        local Explosion = script.BarrageExplosion:Clone()
        Explosion.CFrame = rt.CFrame * CFrame.new(Rand:NextInteger(-4, 4), Rand:NextInteger(-1, 2), Rand:NextInteger(-1, 1))
        Explosion.Parent = workspace.Effects
        VFXModule.Debris(Explosion, 3)
        VFXModule.Emit(Explosion)
        task.wait(.1)
    end

    local Fireball = script.Ball:Clone()
    Fireball.CFrame = unit["Right Arm"].CFrame * CFrame.new(0, -1.5, 0)
    Fireball.Parent = workspace.Effects
    VFXModule.Debris(Fireball, 3)
    VFXModule.EffectToggle(Fireball, true)
    VFXModule.WeldFunction(unit["Right Arm"], Fireball, "FireballWeld")

    task.wait(.35)
    Fireball.FireballWeld:Destroy()
    TweenService:Create(Fireball, TweenInfo.new(.5, Enum.EasingStyle.Quad), {CFrame = CFrame.new(pos.Position) * Fireball.CFrame.Rotation}):Play()

    task.wait(.5)
    
    VFXModule.EffectToggle(Fireball, false)
    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = pos.CFrame * CFrame.new(0, -1, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(pos.CFrame, 12, 12, {baseDestroyWait = 1.5, expandTime = .2})

    task.wait(1)
    rt.CFrame = DefaultCFrame
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
