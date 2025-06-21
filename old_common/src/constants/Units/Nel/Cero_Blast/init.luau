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
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Cero, unit, 1.5, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
    local CeroBlast = script.Orb:Clone()
    CeroBlast.CFrame = rt.CFrame * CFrame.new(0, 0, -1) * CFrame.Angles(0, math.rad(180), 0)
    CeroBlast.Parent = workspace.Effects
    VFXModule.EffectToggle(CeroBlast, true)
    VFXModule.Debris(CeroBlast, 4)

    task.wait(.5)

    TweenService:Create(CeroBlast, TweenInfo.new(.35, Enum.EasingStyle.Quad), {CFrame = CFrame.new(pos.Position) * CeroBlast.CFrame.Rotation}):Play()
    task.wait(.35)
    VFXModule.EffectToggle(CeroBlast, false)

    local Explosion = script.OrbExplosion:Clone()
    Explosion.CFrame = pos.CFrame * CFrame.new(0, -1.5, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(pos.CFrame, 8, 8, {baseDestroyWait = 2})


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
