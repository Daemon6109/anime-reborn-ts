local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

module.config = {
	HitDelay = 1.1, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}
function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)
	local SavedDirection = rt.CFrame.LookVector
	
	emit.enablevfx(unit["Left Arm"].GalickgunCharge,true)
	emit.emitvfx(unit["Left Arm"].GalickgunCharge)

	unit.Torso.shards:Emit(4)
	unit.Torso.shards1:Emit(4)
	unit.Torso.shards12:Emit(4)
	unit.Torso.shards2:Emit(4)

	
	task.wait(.92)
	emit.emitvfx(unit.Torso.jump)
	emit.enablevfx(unit["Left Arm"].GalickgunCharge,false)
	local Galick = script.BeamVegeta:Clone() -- vfx
	Galick.Parent = workspace.Effects
	Galick.CFrame =  rt.CFrame + (rt.CFrame.LookVector * 1.5 + Vector3.new(0,-.2,0))
	emit.enablevfx(Galick,true)
	debris.AddItem(Galick,2.5)

	local info = TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	local tween = tween_service:Create(Galick:FindFirstChild("End"),info,{WorldPosition = (rt.CFrame * CFrame.new(0,0,-12)).Position}) -- tween for the beam to move to the position
	tween:Play()
	
	task.spawn(function()
		local meshvf = script["Shockwave mesh"]:Clone() -- vfx
		meshvf.Parent = workspace.Effects
		meshvf.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + (rt.CFrame.RightVector * -.6)
		meshvf.Orientation = meshvf.Orientation + Vector3.new(90,0,0)

		spr.target(meshvf, 1.3, 5.3, {Size = Vector3.new(3.406, 6.13, 16.267)})
		
		local info = TweenInfo.new(.17,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
		local tween = tween_service:Create(meshvf,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)}) -- tween for the beam to move to the position
		tween:Play()
		
		local TweenComplete = tween_service:Create(meshvf,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()
		task.wait(.17)
		meshvf:Destroy()
	end)
	
	task.spawn(function()
		task.wait(.14)
		local Wind1 = script.Wind1:Clone()
		Wind1.Parent = workspace.Effects
		Wind1.CFrame = rt.CFrame * CFrame.Angles(0,math.rad(-90),0)
		Wind1.Mesh.Scale = Vector3.new(2,0,0)
		debris.AddItem(Wind1,2.5)

		tween_service:Create(Wind1.Mesh, 
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{
				Scale = Vector3.new(.25,.5,.6),
			}
		):Play()
		tween_service:Create(Wind1, 
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{
				CFrame = Wind1.CFrame * CFrame.Angles(math.rad(math.random(-90,90)),0,0)
			}
		):Play()
		tween_service:Create(Wind1.Decal, 
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{Transparency = 1}
		):Play()

		task.wait(.3)
		Wind1:Destroy()

	end)
	

	for i, v in pairs(Galick.Beams:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
				local oldcurve = v.CurveSize0
				local oldcurve2 = v.CurveSize1

				v.Width0 = 0
				v.Width1 = 0
				v.CurveSize0 = 0
				v.CurveSize1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{CurveSize0 = oldcurve})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{CurveSize1 = oldcurve2})
				TweenComplete:Play()

				local info = TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
				local tween = tween_service:Create(v.Parent,info,{WorldPosition = (rt.CFrame * CFrame.new(0,0,-12)).Position}) -- tween for the beam to move to the position
				tween:Play()

				task.wait(.55)
				
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = (oldbeamsize * 5.5)})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = (oldbeamsize2 * 5.5)})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{CurveSize0 = (5.5 * oldcurve)})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{CurveSize1 = (5.5 * oldcurve2)})
				TweenComplete:Play()
				
				task.wait(.2)

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width0 = 0}) --tweens for the beams to dissapear smoothly
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{CurveSize0 = 0}) 
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{CurveSize1 = 0})
				TweenComplete:Play()
			end
		end)
	end		



	wait(.8)
	
	emit.emitvfx(Galick)
	emit.enablevfx(Galick,false)
	emit.enablevfx(Galick.Beams,true)
	emit.emitvfx(unit.Torso.jump)
	unit.Torso.shards:Emit(4)
	unit.Torso.shards1:Emit(4)
	unit.Torso.shards12:Emit(4)
	unit.Torso.shards2:Emit(4)




end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
