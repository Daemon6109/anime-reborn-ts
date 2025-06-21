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
	HitDelay = 3.2, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move4sfx"], rt, Replicated.SoundGroups.UnitSFX)
	

	local charge = script:FindFirstChild("Esdeath4Charge"):Clone()
	charge.Parent = effectsfolder
	charge.Position = rt.Position + Vector3.new(0,-1.2,0)
	debris.AddItem(charge, 4)
	emit.enablevfx(charge,true)
	
	

	task.wait(.75)
	
	
	emit.emitvfx(unit.Torso)
	rt.CFrame = rt.CFrame + Vector3.new(0,21,0)
	task.wait(.05)
	emit.emitvfx(unit.Torso)
	rt.CFrame = CFrame.lookAt(rt.Position, startpos.Position)

	local Charge = script.Esdeath1Charge:Clone() 
	Charge.Parent = workspace.Effects
	Charge.CFrame = rt.CFrame
	emit.emitvfx(Charge)
	debris.AddItem(Charge,6)
	
	task.wait(.2)
	
	emit.enablevfx(charge,false)
	
	local Slashfirst = script.Esdeath4MeteorSlash:Clone() 
	Slashfirst.Parent = workspace.Effects
	Slashfirst.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	emit.emitvfx(Slashfirst)
	debris.AddItem(Slashfirst,3)
	
	task.wait(0.215)
	
	local Meteor = script.IceMeteor:Clone() 
	Meteor.Parent = workspace.Effects
	Meteor.CFrame = rt.CFrame + (rt.CFrame.LookVector * 5.5) + Vector3.new(0,-1,0)
	emit.emitvfx(Meteor)
	emit.enablevfx(Meteor,true)
	debris.AddItem(Meteor,3)
	
	local sizeold = Meteor.Size
	Meteor.Size = Vector3.new(0,0,0)
	
	local TweenComplete = tween_service:Create(Meteor,TweenInfo.new(.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{Size = sizeold})
	TweenComplete:Play()

	
	local Holdingmetoer = script.Esdeath4HoldingMeteor:Clone() 
	Holdingmetoer.Parent = workspace.Effects
	Holdingmetoer.Position =  Meteor.Position + Vector3.new(0,-1,0)
	emit.enablevfx(Holdingmetoer,true)
	debris.AddItem(Holdingmetoer,3)
	
	task.wait(1.05)

	Charge.CFrame = rt.CFrame
	emit.emitvfx(Charge)

	task.wait(.25)
	
	local Punch = script.ShootMeteor:Clone() 
	Punch.Parent = workspace.Effects
	Punch.CFrame = rt.CFrame + (rt.CFrame.LookVector * 8)
	emit.emitvfx(Punch)
	debris.AddItem(Punch,3)
	emit.enablevfx(Holdingmetoer,false)
	emit.emitvfx(Charge)

	local TweenComplete = tween_service:Create(Meteor,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = startpos})
	TweenComplete:Play()
	
	task.wait(.2)
	
	local Impact = script.MeteorBreak:Clone() 
	Impact.Parent = workspace.Effects
	Impact.Position =  Meteor.Position + Vector3.new(0,-1,0)
	emit.emitvfx(Impact)
	debris.AddItem(Impact,3)
	Meteor.Transparency = 1
	emit.enablevfx(Meteor,false)
	rocksmodule.Ground(startpos.Position + Vector3.new(0,1.5,0),20, Vector3.new(1.5, 1.5, 1.5), nil, 13, true, .5) -- ground crack module

	emit.emitvfx(Meteor)

	task.wait(.6)

	emit.emitvfx(unit.Torso)
	rt.CFrame = startpos
	task.wait(.05)
	emit.emitvfx(unit.Torso)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
