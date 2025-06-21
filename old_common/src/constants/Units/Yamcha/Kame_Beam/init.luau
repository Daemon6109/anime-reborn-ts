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
local rn = game:GetService("RunService")

module.config = {
	HitDelay = 1, -- seconds
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .25, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end



local function EmitParticles(part)
	for i,v in part:GetDescendants() do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v:Emit(v:GetAttribute("EmitCount"))
				end 

				local _delay = v:GetAttribute("EmitDuration")
				if _delay then
					v.Enabled = true
					task.delay(_delay, function()
						v.Enabled = false
					end)
				end
			end)()
		end
	end
end


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.15, "", {Weight = 2, Fade = .15})
	
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.1)

	emit.enablevfx(unit["Right Arm"].Kamehamehacharge,true)



	task.spawn(function()
		for i=0,6,1 do
			task.wait(.1)
			emit.bezier(unit["Right Arm"].Kamehamehacharge.WorldCFrame,ColorSequence.new(Color3.fromRGB(255, 241, 38)),0.00000000005,.5,"Long",true,5,.5,1.6)
			task.wait(.1)
			emit.bezier(unit["Right Arm"].Kamehamehacharge.WorldCFrame,ColorSequence.new(Color3.fromRGB(60, 128, 255)),0.00000000005,.5,"Long",true,5,.5,1.6)
		end
	end)

	task.wait(.7)

	local Kamehameha = script.Kamehameha:Clone() -- vfx
	Kamehameha.Parent = workspace.Effects
	Kamehameha.CFrame =  rt.CFrame + (rt.CFrame.LookVector * 1.5 + Vector3.new(0,-.2,0))
	emit.enablevfx(Kamehameha,true)
	
	local endposs = rt.CFrame + (rt.CFrame.LookVector * 14)
	
	local info = TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	local tween = tween_service:Create(Kamehameha:FindFirstChild("end"),info,{WorldPosition = endposs.Position}) -- tween for the beam to move to the position
	tween:Play()


	for i, v in pairs(Kamehameha.beams:GetDescendants()) do -- tween for making the beams appear smooth
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
				local tween = tween_service:Create(v.Parent,info,{WorldPosition = endposs.Position}) -- tween for the beam to move to the position
				tween:Play()

				task.wait(.9)

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



	wait(.25)

	local info = TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	local tween = tween_service:Create(Kamehameha:FindFirstChild("end"),info,{WorldPosition = endposs.Position}) -- tween for the beam to move to the position
	tween:Play()

	wait(1)

	emit.enablevfx(unit["Right Arm"].Kamehamehacharge,false)
	emit.enablevfx(Kamehameha,false)
	emit.enablevfx(Kamehameha.beams,true)
	emit.emitvfx(Kamehameha)
	emit.emitvfx(unit.Torso.jump)


	wait(1)

	debris.AddItem(Kamehameha,1)



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
