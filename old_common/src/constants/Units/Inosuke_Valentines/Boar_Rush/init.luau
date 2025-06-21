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
	HitDelay = 1.55, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
	EndingDelay = .25

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
	local TargetPos = pos.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector


	local newanim =AnimModule.PlayAnim(script.atk2, unit, 1.7, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Atk2"], rt, Replicated.SoundGroups.UnitSFX)
	
	emit.trailonoff(unit,true)

	
	task.wait(.15)
	
	
	emit.emitvfx(unit.Torso.jump)
	
	local info = TweenInfo.new(1.05,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
	local tween = tween_service:Create(rt,info,{CFrame = CFrame.lookAt(rt.Position, TargetPos.Position+SavedDirection)+ (rt.CFrame.LookVector * 18)})
	tween:Play()
	
	local Moving = script.Inosukeatk2Moving:Clone() 
	Moving.Parent = workspace.Effects
	Moving.CFrame = rt.CFrame + (rt.CFrame.LookVector * .6)
	debris.AddItem(Moving,2)


	local info = TweenInfo.new(1.05,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
	local tween = tween_service:Create(Moving,info,{CFrame = CFrame.lookAt(rt.Position, TargetPos.Position+SavedDirection)+ (rt.CFrame.LookVector * 20)})
	tween:Play()
	
	task.wait(.2)
	
	emit.enablevfx(Moving,true)


	wait(.7)
	
	local impac = script.Inosukeatk2impact:Clone() 
	impac.Parent = workspace.Effects
	impac.CFrame = rt.CFrame + (rt.CFrame.LookVector * .6)
	emit.emitvfx(impac)
	debris.AddItem(impac,3)

	emit.enablevfx(Moving,false)

	task.wait(.75)
	
	emit.trailonoff(unit,false)
	unit.Torso.tp:Emit(15)
	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	unit.Torso.tp:Emit(15)



	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
