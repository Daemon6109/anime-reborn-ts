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
	EndingDelay = .25

}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Secondatack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)

	
	local SavedDirection = rt.CFrame.LookVector
	emit.emitvfx(unit.Torso.jump)
	
	emit.trailonoff(unit["Hiei Sword"],true)
	
	task.wait(.2)
	

	local info = TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	local tween = tween_service:Create(rt,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -2.5) }) -- tween to go to the pos
	tween:Play()

	local dash = script.dashpartquicksmaller:Clone()  
	dash.Parent = workspace.Effects
	dash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2) 
	dash.front.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1) 
	emit.emitvfx(dash)

	task.wait(0.37)
	
	emit.emitvfx(unit.Torso.aa)

	

	local slash = script.Slash2:Clone() -- vfx
	slash.Parent = workspace.Effects
	slash.CFrame = rt.CFrame
	emit.emitvfx(slash.slash)
	emit.emitvfx(slash.slash2)
	task.wait(.15)
	emit.emitvfx(slash.hit.Cross)
	emit.enablevfx(slash.hit.Cross,true)
	
	debris.AddItem(slash,2)

	task.wait(.44)
	emit.enablevfx(slash.hit.Cross,false)
	emit.emitvfx(slash.hit.Cross)
	emit.emitvfx(slash.hit.E1)
	emit.emitvfx(slash.hit.E2)
	

	emit.trailonoff(unit,false)

	emit.trailonoff(unit["Hiei Sword"],false)
		
	unit.Torso.tp:Emit(15)
	task.wait(.3)
	rt.CFrame = startpos -- teleporting the unit bac
	task.wait(.03)
	unit.Torso.tp:Emit(15)	



	emit.trailonoff(unit,true)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
