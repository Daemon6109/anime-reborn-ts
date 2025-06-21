local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.4, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	local SavedDirection = rt.CFrame.LookVector

	AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script:FindFirstChild("1"), rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.4)

	emit.enablevfx(unit.Torso.waterwheel,true)

	local info = TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local tween = tween_service:Create(rt,info,{CFrame =  CFrame.lookAt(pos.Position, pos.Position+SavedDirection)}) -- tween to go to the pos
	tween:Play()

	wait(.7)

	emit.emitvfx(unit.Torso.waterwheel.emit)

	wait(.2)

	emit.enablevfx(unit.Torso.waterwheel,false)		

	wait(1)


	unit.Torso.tp:Emit(25) -- teleporting the unit back
	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	unit.Torso.tp:Emit(25)		
	wait(.8)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
