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
	HitDelay = 1.4, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
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

	task.spawn(function()
		for i=0,3,1 do
			wait(.05)
			emit.bezier(unit.UssopBallFire.CFrame,ColorSequence.new(Color3.fromRGB(255, 70, 14)),0.00000000005)
		end
	end)
	AnimModule.PlayAnim(script.secondattack, unit, 1.2, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.spawn(function()
		unit.Weapon.Beams1.RIGHT.BeamR.Attachment1 = unit["Right Arm"].Forbeam
		unit.Weapon.Beams.LEFT.Beam.Attachment1 = unit["Right Arm"].Forbeam
		unit.UssopBallFire.Transparency = 0
		emit.emitvfx(unit.UssopBallFire)
		emit.enablevfx(unit.UssopBallFire,true)

		task.wait(1.2)
		emit.emitvfx(unit.UssopBallFire)

		emit.enablevfx(unit.UssopBallFire,false)
		unit.UssopBallFire.Transparency = 1

		task.wait(.3)

		unit.Weapon.Beams.LEFT.Beam.Attachment1 = unit.Weapon.Beams.LEFT
		unit.Weapon.Beams1.RIGHT.BeamR.Attachment1 = unit.Weapon.Beams1.RIGHT
	end)

	task.wait(1.2)

	emit.emitvfx(unit.Torso.jump)

	local FireBird = script["Firebird star"]:Clone() 
	FireBird.Parent = workspace.Effects
	FireBird.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2)
	emit.enablevfx(FireBird,true)
	emit.emitvfx(FireBird)
	debris.AddItem(FireBird,2.5)

	for i, v in pairs(FireBird:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1


				v.Width0 = 0
				v.Width1 = 0
				v.CurveSize0 = 0
				v.CurveSize1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.11,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.11,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()

				wait(.551)
				v.Enabled = true
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.22,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width0 = 0}) --tweens for the beams to dissapear smoothly
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.22,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()
			end
		end)
	end		
	
	local endposs = rt.CFrame + (rt.CFrame.LookVector * 14)
	
	local info = TweenInfo.new(.65,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local tween = tween_service:Create(FireBird,info,{CFrame = endposs})
	tween:Play()

	wait(.55)
	
	emit.enablevfx(FireBird,false)

	task.wait(.03)
	
	local hit = script.Firebirdimpact:Clone() 
	hit.Parent = workspace.Effects
	hit.Position = FireBird.Position
	emit.emitvfx(hit)
	
	debris.AddItem(hit,1)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
