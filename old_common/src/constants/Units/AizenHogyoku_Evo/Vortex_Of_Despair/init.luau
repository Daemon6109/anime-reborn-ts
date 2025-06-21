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
	HitDelay = .35, -- seconds
	HitCount = 12, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .085, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.VortexAnim, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

    task.spawn(function()
		for i=0,16,1 do
			task.wait(.025)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(103, 69, 255)),0.00000000005,.5,"Mid",true,5,.5,3.6)
		end
	end)

    task.wait(.35)

    local Vortex = script.Vortex:Clone()
    Vortex.CFrame = CFrame.new(pos.Position) * CFrame.new(0, -1, 0)
    Vortex.Parent = workspace.Effects
    VFXModule.Emit(Vortex)
    VFXModule.Debris(Vortex, 3)

    task.spawn(function()
		for i=0, 35,1 do
			task.wait(.03)
			emit.bezier(Vortex.CFrame * CFrame.new(Rand:NextInteger(-24, 24), Rand:NextInteger(2, 16), Rand:NextInteger(-24, 24)) ,ColorSequence.new(Color3.fromRGB(103, 69, 255)),0.00000000005,.5,"Long",true, 5, 0, 5)
		end
	end)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
