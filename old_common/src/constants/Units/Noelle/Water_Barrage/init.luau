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
local bezierModule = require(script.BezierModule)

module.config = {
	HitDelay = 1.2, -- seconds
	HitCount = 8, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
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

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.55, "Mainaim", {Weight = 2, Fade = .15})


	local Character = unit
	
	
	local startwater = script.NoelleMOvestart:Clone()
	startwater.Parent = effectsfolder
	startwater.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1) 
	debris.AddItem(startwater,3)
	emit.enablevfx(startwater,true)
	
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local OriginalCFrame = Character.HumanoidRootPart.CFrame

	for i = 1,8 do
		task.wait(.2)
		spawn(function()

			local KiBlast = script.MediumWater:Clone()
			KiBlast.Parent = effectsfolder
			KiBlast.CFrame = OriginalCFrame 
			debris.AddItem(KiBlast,3)
			emit.emitvfx(KiBlast)

			--local Sound = Assets.Sounds.RocketLaunch:Clone()
			--Sound.Parent = character.PrimaryPart
			--Sound:Play()
			
			local StartPositionn = rt.CFrame + (rt.CFrame.LookVector * 1)
			local StartPosition = StartPositionn.Position			
			KiBlast.CFrame = CFrame.lookAt(StartPosition, pos.Position)
			local randomPos = pos.Position + Vector3.new(math.random(0.3,1),0,math.random(.3,1))
			local EndPosition = randomPos

			local Magnitude = (StartPosition - EndPosition).Magnitude
			local Midpoint = (StartPosition - EndPosition)/2

			local PointA = (CFrame.new(CFrame.new(StartPosition)  * (Midpoint/.75)) * CFrame.Angles(math.rad(-90),0,0)) .Position  -- first 25% of the path
			local PointB = (CFrame.new(CFrame.new(EndPosition) * (Midpoint/.75) ) * CFrame.Angles(math.rad(-90),0,0)).Position  -- last 25% of the path

			local Offset = Magnitude/2
			PointA = PointA + Vector3.new(math.random(-Offset,Offset),math.random(1, 4),math.random(-Offset,Offset))
			PointB = PointB + Vector3.new(math.random(-Offset,Offset),math.random(1, 4),math.random(-Offset,Offset))
			local Speed = .7;
			for i = 1, Magnitude, Speed do
				local Percent = i/Magnitude
				local Coordinate = bezierModule:cubicBezier(Percent, StartPosition, PointA, PointB, EndPosition)
				KiBlast.CFrame = KiBlast.CFrame:Lerp(CFrame.new(Coordinate, EndPosition)* CFrame.fromEulerAnglesXYZ(math.rad(10),0,math.rad(90)), Percent) 

				local nextPoint = ((i+1) < Magnitude and bezierModule:cubicBezier((i+1)/Magnitude,StartPosition,PointA,PointB,EndPosition) or bezierModule:cubicBezier(1,StartPosition,PointA,PointB,EndPosition))

				game:GetService("RunService").Heartbeat:Wait()
			end
			local Explosion = script.Explosion:Clone()
			Explosion.Parent = effectsfolder
			Explosion.CFrame = CFrame.new(EndPosition)
			debris.AddItem(Explosion,3)
			--Camera.Start("Soft")

			for i,v in pairs(Explosion:GetDescendants()) do if v:IsA("ParticleEmitter") then v:Emit(v:GetAttribute("EmitCount")) end end
			KiBlast.Transparency = 1
			for i,v in pairs(KiBlast:GetDescendants())do
				if v:IsA("ParticleEmitter") then
					v.Enabled = false
				end
			end



		end)
	end
	
	emit.enablevfx(startwater,false)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
