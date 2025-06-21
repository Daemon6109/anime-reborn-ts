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
	HitDelay = .75, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .125, -- delay between hits in a multi-hit move
}

local Rand = Random.new()


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Materella, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
    local Charge = script.Charge:Clone()
    Charge.CFrame = rt.CFrame * CFrame.new(0, .6, -2)
    Charge.Parent = workspace.Effects
    VFXModule.EffectToggle(Charge, true)
    VFXModule.Debris(Charge, 5)

    task.wait(.755)

    for i = 1, 10 do
        task.spawn(function()
            local Cero = script.Beam:Clone()
            Cero.CFrame = Charge.CFrame * CFrame.new(Rand:NextInteger(-12, 12), Rand:NextInteger(-1, 4), Rand:NextInteger(-2, 2)) * CFrame.Angles(0, math.rad(-90), 0)
            Cero.Parent = workspace.Effects
            VFXModule.Emit(Cero)
            VFXModule.EffectToggle(Cero, true)
            VFXModule.Debris(Cero, 3)
        
            task.wait(.5)
            VFXModule.EffectToggle(Charge, false)
            VFXModule.EffectToggle(Cero, false)
        end)

        task.wait(Rand:NextNumber(.1, .2))
    end

    VFXModule.EffectToggle(Charge, false)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
