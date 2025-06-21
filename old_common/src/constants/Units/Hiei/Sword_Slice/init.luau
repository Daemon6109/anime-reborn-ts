local module = {}


local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
	EndingDelay = .25

}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)
	emit.trailonoff(unit["Hiei Sword"],true)


	emit.trailonoff(unit,false)

	emit.emitvfx(unit.Torso.tp)
	task.wait(.12)
	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -1.5)
	task.wait(.03)
	emit.emitvfx(unit.Torso.tp)
	
	emit.trailonoff(unit,true)

	task.wait(0.1)
	
	emit.emitvfx(unit.Torso.aa)
	
	task.wait(0.1)
	
	local slash = script.Slash:Clone() -- vfx
	slash.Parent = workspace.Effects
	slash.CFrame = rt.CFrame
	emit.emitvfx(slash)
	
	debris.AddItem(slash,2)

	task.wait(.6)
	emit.trailonoff(unit,false)

	emit.trailonoff(unit["Hiei Sword"],false)


	unit.Torso.tp:Emit(15)
	task.wait(.12)
	rt.CFrame = startpos -- teleporting the unit bac
	task.wait(.03)
	unit.Torso.tp:Emit(15)	
	emit.trailonoff(unit,true)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
