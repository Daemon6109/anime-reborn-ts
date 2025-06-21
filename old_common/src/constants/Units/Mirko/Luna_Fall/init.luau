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
	HitDelay = 1.4, -- seconds
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
    SoundWrapper:PlaySound(script.LunaFallSound, rt)

    task.wait(.75)

    TweenService:Create(rt, TweenInfo.new(.35, Enum.EasingStyle.Quad), {CFrame =  CFrame.new(pos.Position) * DefaultCFrame.Rotation * CFrame.new(0, 12, 4)}):Play()

    task.wait(.35)

    TweenService:Create(rt, TweenInfo.new(.35, Enum.EasingStyle.Quad), {CFrame = pos.CFrame * rt.CFrame.Rotation * CFrame.new(0, 0, 1)}):Play()

    task.wait(.35)

    local Explosion = script.LunaFall:Clone()
    Explosion.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(rt.CFrame, 12, 12, {baseDestroyWait = 2})

    task.wait(1)

    rt.CFrame = DefaultCFrame
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
