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
	HitDelay = 1.5, -- seconds
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
    SoundWrapper:PlaySound(script.SpiritBomb, rt)    

    local SpiritBomb = script.Ball:Clone()
    SpiritBomb.CFrame = rt.CFrame * CFrame.new(0, 16, 0)
    SpiritBomb.Parent = workspace.Effects
    VFXModule.Debris(SpiritBomb, 3)
    VFXModule.EffectToggle(SpiritBomb, true)

    task.wait(.75)
    TweenService:Create(SpiritBomb, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {CFrame = CFrame.new(pos.Position) * SpiritBomb.CFrame.Rotation}):Play()

    task.wait(1.2)
    
    VFXModule.EffectToggle(SpiritBomb, false)
    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = pos.CFrame * CFrame.new(0, -1, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(pos.CFrame, 16, 12, {baseDestroyWait = 1.5, expandTime = .2})
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
