local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.7, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
	--CustomDelay = {
	--	[8] = .9,
	--},
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.thirdattack, unit, 1, "", {Weight = 2, Fade = .15})
	
	SoundWrapper:PlaySound(script["3"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.8)

	local fireball = script.Kakashifir3eball:Clone() 
	fireball.Parent = workspace.Effects
	fireball.CFrame = unit.Head.CFrame + (rt.CFrame.LookVector * .7)
	debris.AddItem(fireball,2.5)

	emit.enablevfx(fireball.fire,true)
	
	task.wait(.3)
	
	local recoil = script.recoil2:Clone() 
	recoil.Parent = workspace.Effects
	recoil.CFrame = rt.CFrame
	emit.emitvfx(recoil)
	debris.AddItem(recoil,2.5)


	local info = TweenInfo.new(.27,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	local tween = tween_service:Create(fireball,info,{CFrame = pos.CFrame}) -- tween to go to the pos
	tween:Play()
	
	task.wait(.27)
	
	emit.emitvfx(fireball.impactemit)
	emit.enablevfx(fireball.fire,false)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
