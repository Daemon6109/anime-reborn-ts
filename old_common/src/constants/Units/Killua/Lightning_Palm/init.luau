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
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector

	local animation = humanoid:LoadAnimation(AnimModule.GetAnim(script.firstattack))
	animation:Play()

	AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)


	emit.enablevfx(unit["Right Arm"].Palm,true)
	emit.enablevfx(unit["Left Arm"].Palm,true)


	task.wait(.3)


	local info = TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	local tween = tween_service:Create(rt,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -1.5) }) -- tween to go to the pos
	tween:Play()
	
	local dash = script.dashpartquicksmaller:Clone()  
	dash.Parent = workspace.Effects
	dash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2) 
	dash.front.CFrame = rt.CFrame + (rt.CFrame.LookVector * 4) 
	emit.emitvfx(dash)
	debris.AddItem(dash,2)

	task.wait(.25)
	

	local im = script.Lightpalmimpact:Clone()  
	im.Parent = workspace.Effects
	im.Position = pos.Position
	emit.emitvfx(im)	
	debris.AddItem(im,2.5)

	task.wait(.3)

	emit.enablevfx(unit["Right Arm"].Palm,false)
	emit.enablevfx(unit["Left Arm"].Palm,false)


	task.wait(.55)
	
	unit.Torso.tp:Emit(15)
	task.wait(.12)
	rt.CFrame = startpos -- teleporting the unit bac
	task.wait(.03)
	unit.Torso.tp:Emit(15)	


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
