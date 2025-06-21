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
	HitDelay = .85, -- seconds
	HitCount = 12, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .08, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Cero, unit, .8, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
    local Charge = script.Charge:Clone()
    Charge.CFrame = rt.CFrame * CFrame.new(0, .7, -.8)
    Charge.Parent = workspace.Effects
    VFXModule.EffectToggle(Charge, true)
    VFXModule.Debris(Charge, 4)

    task.wait(1.5)

    local Cero = script.Beam:Clone()
    Cero.CFrame = Charge.CFrame * CFrame.Angles(0, math.rad(180), 0)
    Cero.Parent = workspace.Effects
    VFXModule.Emit(Cero)
    VFXModule.EffectToggle(Cero, true)
    VFXModule.Debris(Cero, 4)

    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = pos.CFrame * CFrame.new(0, -1.5, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 4)
    VFXModule.Emit(Explosion)

    task.wait(1.5)
    VFXModule.GroundExpandV2(pos.CFrame, 20, 16, {baseDestroyWait = 2})

    task.wait(1)
    VFXModule.EffectToggle(Charge, false)
    VFXModule.EffectToggle(Cero, false)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
