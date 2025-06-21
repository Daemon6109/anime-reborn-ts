local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local VFXModule = require(Replicated.Libs.VFXModule)

module.config = {
	HitDelay = .75, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

    local TrailBool = true

    task.spawn(function()
		repeat task.wait(.025)
			task.wait(.025)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(103, 69, 255)),0.00000000005,.5,"Long",true,5,0,5)
        until not TrailBool
	end)

    task.wait(.5)

	AnimModule.PlayAnim(script.WalkAnim, unit, 1, "Walk", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

    local FlameRelease = script.FlameRelease:Clone()
    FlameRelease.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0)
    FlameRelease.Parent = workspace.Effects
    VFXModule.Debris(FlameRelease, 4)
    VFXModule.Emit(FlameRelease)
    VFXModule.EffectToggle(FlameRelease, true)

    VFXModule.WeldFunction(rt, FlameRelease, "FlameReleaseWeld")

    task.wait(.25)

    TweenService:Create(rt, TweenInfo.new(2), {CFrame = CFrame.new(pos.Position) * rt.CFrame.Rotation}):Play()

    task.wait(1.5)

    task.spawn(function()
		for i=0, 35, 1 do
			task.wait(.03)
			emit.bezier(rt.CFrame * CFrame.new(Rand:NextInteger(-36, 36), Rand:NextInteger(2, 24), Rand:NextInteger(-36, 36)) ,ColorSequence.new(Color3.fromRGB(103, 69, 255)),0.00000000005,2,"Long",true, 5, 0, 5)
		end
	end)

    task.wait(.5)
    TrailBool = false
    VFXModule.EffectToggle(FlameRelease, false)
    VFXModule.GroundExpandV2(rt.CFrame, 18, 12, {baseDestroyWait = 2})

    local Explosion = script.ReiatsuExplosion:Clone()
    Explosion.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)

    AnimModule.StopAnim(unit, "Walk")

    task.wait(.5)
    rt.CFrame = DefaultCFrame


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
