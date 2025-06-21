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
	HitDelay = .5, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .6, -- delay between hits in a multi-hit move
}



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


	local newanim =	AnimModule.PlayAnim(script.secondattack, unit, 1.7, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)
	
	
	task.wait(.15)

	emit.emitvfx(unit.Torso.jump)

	local Send = script.Atk2Send:Clone() 
	Send.Parent = workspace.Effects
	Send.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	emit.emitvfx(Send)
	debris.AddItem(Send,2.5)

	local info = TweenInfo.new(.55,Enum.EasingStyle.Sine,Enum.EasingDirection.In)
	local tween = tween_service:Create(rt,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)})
	tween:Play()
	
	local Moving = script.Atk2moving:Clone() 
	Moving.Parent = workspace.Effects
	Moving.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	emit.enablevfx(Moving,true)
	debris.AddItem(Moving,2.5)


	local info = TweenInfo.new(.55,Enum.EasingStyle.Sine,Enum.EasingDirection.In)
	local tween = tween_service:Create(Moving,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * 1.5)})
	tween:Play()

	wait(.53)
	emit.enablevfx(Moving,false)

	emit.emitvfx(unit["Right Leg"].Atk2End)
	task.wait(.2)

	AnimModule.ChangeAnimSpeed(newanim,1)

	task.wait(.5)
	
	emit.trailonoff(unit["Right Leg"],false)
	unit.Torso.tp:Emit(15)
	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	unit.Torso.tp:Emit(15)
	emit.trailonoff(unit["Right Leg"],true)



	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
