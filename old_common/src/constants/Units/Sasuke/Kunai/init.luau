local module = {}


local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .65, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	local SavedDirection = rt.CFrame.LookVector
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)

	wait(.2)

	emit.emitvfx(unit.Torso.jump)

	local kunai = script.Blade:Clone() -- vfx
	kunai.Parent = workspace.Effects
	kunai.CFrame =rt.CFrame + (rt.CFrame.LookVector * 1)
	kunai.Orientation = kunai.Orientation + Vector3.new(-90,0,0)
	debris.AddItem(kunai,2.5)

	emit.enablevfx(kunai,true)
	emit.emitvfx(kunai.Still)
	local SavedDirection = rt.CFrame.LookVector

	local info = TweenInfo.new(.3,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
	local tween = tween_service:Create(kunai,info,{Position = pos.Position}) -- tween for the orb
	tween:Play()

	wait(.3)
	
	emit.emitvfx(kunai.Smoke)
	kunai.Transparency = 1

	local ImpactVfx = script.ImpactVfx:Clone() -- vfx
	ImpactVfx.Parent = workspace.Effects
	ImpactVfx.Position = pos.Position
	emit.emitvfx(ImpactVfx)
	debris.AddItem(ImpactVfx,2.5)

	

	task.wait(.2)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
