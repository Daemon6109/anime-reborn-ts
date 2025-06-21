local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

module.config = {
	HitDelay = .6, -- seconds
	HitCount = 8, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}


function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end
local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	local anim = AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Charge"], rt, Replicated.SoundGroups.UnitSFX)

	AnimModule.ChangeAnimSpeed(anim,.8)

	local charge = script.HasteCharge:Clone() -- vfx
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-1,0)
	emit.enablevfx(charge,true)	

	task.spawn(function()
		for i=0,7,1 do
			task.wait(.1)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 77, 17)),0.0005,.7,"Mid",true,6,.5,1.4)
		end
	end)

	task.wait(.65)
	SoundWrapper:PlaySound(script["Impact"], rt, Replicated.SoundGroups.UnitSFX)
	emit.emitvfx(unit.Torso.jump)
	local haste = script.Haste:Clone() -- vfx
	haste.Parent = workspace.Effects
	haste.Position = pos.Position
	emit.emitvfx(haste)
	emit.emitvfx(charge)
	emit.enablevfx(charge,false)
	
	debris.AddItem(charge,2)
	debris.AddItem(haste,2)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
