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

	AnimModule.PlayAnim(script.Beam, unit, 1.5, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
    task.wait(.5)

    local Cero = script.Cero:Clone()
    Cero:PivotTo(rt.CFrame * CFrame.new(0, 3, 2))
    Cero.Parent = workspace.Effects
    VFXModule.Emit(Cero)
    VFXModule.EffectToggle(Cero, true, false, false)
    VFXModule.Debris(Cero, 3)

    task.wait(.01)
    for _, v in pairs(Cero:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v.Enabled = true
            print(v.Enabled)
        end
    end

    for _, v in pairs(Cero:GetDescendants()) do
        if v:IsA("Beam") then
            local W0, W1 = v.Width0, v.Width1
            v.Width0, v.Width1 = 0, 0
            TweenService:Create(v, TweenInfo.new(.35), {Width0 = W0, Width1 = W1}):Play()
        end
    end

    task.wait(1)

    for _, v in pairs(Cero:GetDescendants()) do
        if v:IsA("Beam") then
            TweenService:Create(v, TweenInfo.new(.35), {Width0 = 0, Width1 = 0}):Play()
        end
    end

    VFXModule.EffectToggle(Cero, false, true)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
