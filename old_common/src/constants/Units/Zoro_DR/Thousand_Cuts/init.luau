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
	HitDelay = .25, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    task.spawn(function()
		for i=0,16,1 do
			task.wait(.025)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(103, 69, 255)),0.00000000005,.5,"Mid",true,5,.15,3.6)
		end
	end)


    task.wait(1)

    local Tornado = script.Tornado:Clone()
    Tornado.CFrame = rt.CFrame * CFrame.new(0, 0, -1) * CFrame.Angles(0, 0, math.rad(180))
    Tornado.Parent = workspace.Effects
    VFXModule.EffectToggle(Tornado, true)
    VFXModule.Debris(Tornado, 4)

    TweenService:Create(Tornado, TweenInfo.new(.5, Enum.EasingStyle.Quad), {CFrame = CFrame.new(pos.Position) * Tornado.CFrame.Rotation}):Play()

    task.wait(.5)
    VFXModule.EffectToggle(Tornado, false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
