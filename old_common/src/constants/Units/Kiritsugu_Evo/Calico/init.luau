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
	HitDelay = .9, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .06, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

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
	local SavedDirection = rt.CFrame.LookVector
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.6, "", {Weight = 2, Fade = .15})
	
	task.spawn(function()
		task.wait(.3)
		SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	end)
	
	
	task.wait(.2)

	emit.emitvfx(unit.Torso.jump)
	
	task.wait(.34)
	
	local mainfx = script.Kiritsuguatk2:Clone() 
	mainfx.Parent = workspace.Effects
	mainfx.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2) + (rt.CFrame.RightVector * .3)
	debris.AddItem(mainfx,3)
	emit.enablevfx(mainfx,true)
	emit.emitbeam(mainfx.beamemits,.9,0.55,.55)


	for i = 0,6,1 do
		task.wait(.05)
		
		task.spawn(function()
			emit.emitvfx(unit["M1911 .45"])
		end)
	end	
	task.wait(.3)
	emit.enablevfx(mainfx,false)
		
	task.wait(.05)
	
	local emitend = script.Kiritsuguatk2EMIT:Clone() 
	emitend.Parent = workspace.Effects
	emitend.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2) + (rt.CFrame.RightVector * .3)
	debris.AddItem(emitend,3)
	emit.emitvfx(emitend)
	emit.emitbeam(emitend.beamemits,.9,0.55,.55)
	
	emit.emitvfx(unit.Torso.jump)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
