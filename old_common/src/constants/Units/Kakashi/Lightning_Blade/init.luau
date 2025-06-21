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
	--CustomDelay = {
	--	[8] = .9,
	--},
}

function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	local SavedDirection = rt.CFrame.LookVector

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.2)
	
	local dash = script.dashpartquicksmaller:Clone()  
	dash.Parent = workspace.Effects
	dash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1) 
	dash.front.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2) 
	emit.emitvfx(dash)
	debris.AddItem(dash,2.5)

	emit.enablevfx(unit["Left Arm"].Blade,true)


	local info = TweenInfo.new(.7,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	local tween = tween_service:Create(rt,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)}) -- tween to go to the pos
	tween:Play()

	task.wait(.7)
	

	local slash = script.LightningSlash:Clone() 
	slash.Parent = workspace.Effects
	slash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 0) 
	emit.emitvfx(slash)
	debris.AddItem(slash,2.5)

	task.wait(.5)
	

	emit.enablevfx(unit["Left Arm"].Blade,false)


	task.wait(.2)

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
