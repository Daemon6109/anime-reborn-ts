local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

local spr = require(game.ReplicatedStorage.Libs.emit.spr)

module.config = {
	HitDelay = .85, -- seconds
	Duration = 1,
	TurnTime = .7,
	StunTime = 5,
	AttackRange = 35,
	AttackSize = 15,
}

for i,v in script:GetDescendants() do
	if v:IsA("BasePart") and not v:HasTag("NoAnchor") then
		v.Anchored = true
	end
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector	
	local startpos = rt.CFrame

	local effectsfolder = workspace.Effects

	local charge = script["Okarun move charge"]:Clone() 
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-1.3,0)
	emit.enablevfx(charge,true)

	local newanim = AnimModule.PlayAnim(script.Firstattack, unit, 1.15, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["move1"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.5)

	emit.enablevfx(charge,false)
	
	

	local dash = script["Atk1 Dash"]:Clone() 
	dash.Parent = workspace.Effects
	dash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1.4)
	emit.emitvfx(dash)	
	debris.AddItem(dash,3)
	emit.emitbeam(dash.beamemits,.3,0.5,.35)
	
	local dashb = script["Atk1 Bottom"]:Clone() 
	dashb.Parent = workspace.Effects

	dash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1.4)
	dashb.CFrame = rt.CFrame + (rt.CFrame.LookVector * 6)
	dash.Sideparts.CFrame = rt.CFrame + (rt.CFrame.LookVector * 6) + (rt.CFrame.RightVector * 2.5)
	dash.Sideparts2.CFrame = rt.CFrame + (rt.CFrame.LookVector * 6) + (rt.CFrame.RightVector * -2.5)


	emit.emitvfx(dash)
	emit.emitvfx(dashb)

	debris.AddItem(dash,3)
	debris.AddItem(dashb,3)
	
	CFrame.lookAt(pos.Position, pos.Position+SavedDirection)
	
	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.31,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = rt.CFrame + (rt.CFrame.LookVector * 19)})
	TweenComplete:Play()
	
	task.spawn(function()
		local meshvf = script.WindSwirls:Clone() -- vfx
		meshvf.Parent = workspace.Effects
		meshvf.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1.4)
		spr.target(meshvf, 1.2, 3, {Size = Vector3.new(3.81, 14.823, 3.504)})
		spr.target(meshvf, 1.5, 3, {CFrame = rt.CFrame + (rt.CFrame.LookVector * 10.4)})

		local TweenComplete = tween_service:Create(meshvf,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0),{Orientation = meshvf.Orientation + Vector3.new(0,110,0)})
		TweenComplete:Play()
		local TweenComplete = tween_service:Create(meshvf,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0),{Transparency = 1})
		TweenComplete:Play()
		task.wait(.8)
		meshvf:Destroy()
	end)

	

	emit.emitvfx(unit.Torso.jump)

	AnimModule.ChangeAnimSpeed(newanim,1.6)
	
	task.wait(.31)
	
	emit.emitvfx(unit.Torso.jump)
	AnimModule.ChangeAnimSpeed(newanim,1)

	task.wait(.19)
	
	local phone = script.Phone:Clone() 
	phone.Parent = workspace.Effects
	phone.CFrame = rt.CFrame + Vector3.new(0,.6,0) + (rt.CFrame.LookVector * .5)
	emit.emitvfx(phone.Emit)
	debris.AddItem(phone,2)

	
	local TweenComplete = tween_service:Create(phone,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0),{Orientation = phone.Orientation + Vector3.new(0,110,88)})
	TweenComplete:Play()
	
	local TweenComplete = tween_service:Create(phone,TweenInfo.new(.6,Enum.EasingStyle.Sine,Enum.EasingDirection.In,3,true),{Position = phone.Position + Vector3.new(0,-.65,0)})
	TweenComplete:Play()


	task.wait(.35)
	
	emit.emitvfx(phone.Tp)
	
	phone.Transparency = 1
	
	unit.Torso.tp:Emit(15)
	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	emit.emitvfx(unit.Torso)
	AnimModule.ChangeAnimSpeed(newanim,1)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
