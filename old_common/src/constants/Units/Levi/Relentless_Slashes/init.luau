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
		repeat task.wait(.085)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255,255,255)),0.00000000005,.5,"Long",true,5,0,5)
        until not TrailBool
	end)

    task.wait(.5)

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})
    SoundWrapper:PlaySound(script.LeviSlashes, rt)    
    task.wait(.25)


    for i = 1, 8 do
        local EndCFrame

    
        if i == 8 then
            EndCFrame = CFrame.new(pos.Position) * DefaultCFrame.Rotation
        else
            EndCFrame = CFrame.new(DefaultCFrame.Position:Lerp(pos.Position, i / 8) + Vector3.new(Rand:NextInteger(-24, 24), Rand:NextInteger(0, 8), Rand:NextInteger(-24, 24)), pos.Position)
        end

        TweenService:Create(rt, TweenInfo.new(.35, Enum.EasingStyle.Quad), {CFrame = EndCFrame}):Play()

        task.wait(.3)

        
        local Explosion = script.Slash:Clone()
        Explosion.CFrame = EndCFrame * CFrame.new(0, -1, 0)
        Explosion.Parent = workspace.Effects
        VFXModule.Debris(Explosion, 3)
        VFXModule.Emit(Explosion)

        task.wait(.15)
    end

    TrailBool = false


    task.wait(.5)
    rt.CFrame = DefaultCFrame


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
