local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.2, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .25, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)


	task.wait(.6)

	emit.emitvfx(unit.Torso.Sharingan)

	task.wait(0.4)
	
	emit.emitvfx(unit.Torso.Ready)
	
	task.wait(.2)


	local amaterasu = script.Amaterasu:Clone()  
	amaterasu.Parent = workspace.Effects
	amaterasu.Position = pos.Position + Vector3.new(0,-.7,0)
	emit.emitvfx(amaterasu,emit)
	emit.enablevfx(amaterasu,true)

	task.wait(1)

	emit.enablevfx(amaterasu,false)

	debris.AddItem(amaterasu,1)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
