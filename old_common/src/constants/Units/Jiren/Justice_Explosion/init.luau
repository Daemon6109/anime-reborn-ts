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
	HitCount = 12, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .085, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})
    SoundWrapper:PlaySound(script.JirenExplosion, rt)    

    task.spawn(function()
		for i=0,24,1 do
			task.wait(.025)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(233, 158, 43)),0.00000000005,.5,"Mid",true,5,.5, 12)
		end
	end)

    task.wait(.75)

    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = rt.CFrame * CFrame.new(0, 1, 0) * CFrame.Angles(0, math.rad(90), math.rad(90))
    Explosion.Parent = workspace.Effects
    VFXModule.EffectToggle(Explosion, true)
    VFXModule.Emit(Explosion)
    VFXModule.Debris(Explosion, 5)
    VFXModule.GroundExpandV2(rt.CFrame, 28, 24, {baseDestroyWait = 2.5, expandTime = .2})

    for _, v in pairs(Explosion:GetDescendants()) do
        if v:IsA("Beam") then
            local W0, W1 = v.Width0, v.Width1
            v.Width0, v.Width1 = 0, 0
            TweenService:Create(v, TweenInfo.new(.35), {Width0 = W0, Width1 = W1}):Play()
        end
    end

    task.wait(1)

    task.spawn(function()
		for i=0, 50,1 do
			task.wait(.03)
			emit.bezier(Explosion.CFrame * CFrame.new(Rand:NextInteger(-36, 36), Rand:NextInteger(2, 36), Rand:NextInteger(-36, 36)) ,ColorSequence.new(Color3.fromRGB(233, 158, 43)),0.00000000005,.5,"Long",true, 5, 0, 16)
		end
	end)

    task.wait(1.15)

    for _, v in pairs(Explosion:GetDescendants()) do
        if v:IsA("Beam") then
            TweenService:Create(v, TweenInfo.new(.35), {Width0 = 0, Width1 = 0}):Play()
        end
    end

    task.wait(.35)
    VFXModule.EffectToggle(Explosion, false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
