local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

module.config = {
	HitDelay = 1, -- seconds
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

	task.wait(.2)



	local info = TweenInfo.new(.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	local tween = tween_service:Create(rt,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (pos.CFrame.LookVector * -1)})  -- tween to go to the pos
	tween:Play()

	task.wait(.4)		

	local hit = script.groundsmash:Clone() -- vfx
	hit.Parent = workspace.Effects
	hit.Position =  rt.Position + (rt.CFrame.LookVector * 1 + Vector3.new(0,-1,0))
	emit.emitvfx(hit)
	debris.AddItem(hit,2.5)

	task.wait(.4)



	unit.Torso.tp:Emit(25) -- teleporting the unit back
	task.wait(.12)
	rt.CFrame = startpos
	task.wait(.03)
	unit.Torso.tp:Emit(25)		

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
