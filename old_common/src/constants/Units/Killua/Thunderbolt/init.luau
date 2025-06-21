local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.6, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Secondatack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)


	task.wait(.2)

	emit.enablevfx(unit.Lightningoblt,true)

	emit.emitvfx(unit.Torso.jump)

	task.wait(.75)


	emit.enablevfx(unit.Lightningoblt,false)

	task.wait(.15)
	emit.emitvfx(unit.Torso.jump)

	local bolt = script.Lightningoblt:Clone()
	bolt.Parent = workspace.Effects
	bolt.CFrame = unit.Lightningoblt.CFrame
	emit.enablevfx(bolt,true)
	debris.AddItem(bolt,2)

	bolt.CFrame = CFrame.lookAt(bolt.Position, pos.Position)
	
	local info = TweenInfo.new(.15,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	local tween = tween_service:Create(bolt,info,{Position = pos.Position + Vector3.new(0,-1,0)}) -- making the unit float
	tween:Play()

	task.wait(.15)

	emit.enablevfx(bolt,false)


	local im = script.Thunderboltimpactg:Clone()  
	im.Parent = workspace.Effects
	im.Position = pos.Position + Vector3.new(0,-1,0)
	emit.emitvfx(im)	
	debris.AddItem(im,2.5)





	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
