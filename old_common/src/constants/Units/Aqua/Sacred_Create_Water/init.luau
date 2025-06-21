local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(script.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

module.config = {
	HitDelay = 1, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .25, -- delay between hits in a multi-hit move
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

	local newanim = AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	AnimModule.ChangeAnimSpeed(newanim,3.9)
	
	local charge = script.AquawaterCharge:Clone() -- vfx
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-1,0)
	emit.enablevfx(charge,true)	
	debris.AddItem(charge,2.5)

	task.spawn(function()
		for i=0,7,1 do
			task.wait(.1)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(15, 99, 255)),0.0005,.7,"Mid",true,6,.5,2)
		end
	end)
	
	
	for i, v in pairs(charge:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1

				v.Width0 = 0
				v.Width1 = 0


				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()

				task.wait(.45)


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
	
	task.wait(.6)
	
	AnimModule.ChangeAnimSpeed(newanim,1)
	
	emit.emitvfx(unit.Torso.jump)
	SoundWrapper:PlaySound(script["Impact"], rt, Replicated.SoundGroups.UnitSFX)
	emit.enablevfx(charge,false)	

	emit.enablevfx(unit["Left Arm"].GalickgunCharge,false)
	
	local Flood = script.AquaFloodTop:Clone() -- vfx
	Flood.Parent = workspace.Effects
	Flood.Position = pos.Position + Vector3.new(0,14.6,0)
	emit.enablevfx(Flood,true)
	debris.AddItem(Flood,2.5)

		
	local bottomofbeam = Flood.Top.Attachment:FindFirstChild("1")
	local oldpos = bottomofbeam.Position
	bottomofbeam.Position = Vector3.new(0,0,0)
	
	local info = TweenInfo.new(.2,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
	local tween = tween_service:Create(bottomofbeam,info,{WorldPosition = pos.Position}) -- tween for the beam to move to the position
	tween:Play()
	

	for i, v in pairs(bottomofbeam:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
	
				v.Width0 = 0
				v.Width1 = 0
	

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()
	
				task.wait(.7)
				
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = (oldbeamsize * 3.5)})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = (oldbeamsize2 * 3.3)})
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
	emit.enablevfx(Flood,false)
	emit.enablevfx(bottomofbeam,true)
	bottomofbeam.impactsreal.Enabled = false
	task.wait(.15)
	emit.emitvfx(Flood.jump)
	emit.emitvfx(Flood.Top)
	emit.emitvfx(Flood.Btm)
	Flood.waterem:Emit(7)
	Flood.waterbublesem:Emit(7)
	Flood.waterrem:Emit(7)

	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
