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
	HitDelay = 1, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.4)

	local Slashfirst = script.Esdeath1Slash1:Clone() 
	Slashfirst.Parent = workspace.Effects
	Slashfirst.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	emit.emitvfx(Slashfirst)
	debris.AddItem(Slashfirst,3)
	
	task.wait(.2)
	
	local Charge = script.Esdeath1Charge:Clone() 
	Charge.Parent = workspace.Effects
	Charge.CFrame = rt.CFrame
	emit.emitvfx(Charge)
	debris.AddItem(Charge,3)
	
	
	task.wait(.26)
	
	local Slashfirst2 = script.Esdeath1Slash2:Clone() 
	Slashfirst2.Parent = workspace.Effects
	Slashfirst2.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	emit.emitvfx(Slashfirst2)
	debris.AddItem(Slashfirst2,3)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
