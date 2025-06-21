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
	HitDelay = .7, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "Mainaim", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local Character = unit

	local OriginalCFrame = Character.HumanoidRootPart.CFrame

	local startwater = script.NoelleMOvestart:Clone()
	startwater.Parent = effectsfolder
	startwater.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1) 
	debris.AddItem(startwater,3)
	emit.enablevfx(startwater,true)
	
	task.wait(.55)
	
	spawn(function()

		local KiBlast = script.WaterBall:Clone()
		KiBlast.Parent =effectsfolder
		KiBlast.CFrame = OriginalCFrame 


		local StartPositionn = rt.CFrame + (rt.CFrame.LookVector * 1)
		local StartPosition = StartPositionn.Position
		KiBlast.CFrame = CFrame.lookAt(StartPosition, pos.Position)
		local randomPos = pos.Position + Vector3.new(math.random(-1,1),0,math.random(-1,1))
		local EndPosition = randomPos

		local Magnitude = (StartPosition - EndPosition).Magnitude
		local Midpoint = (StartPosition - EndPosition)/2

		local PointA = (CFrame.new(CFrame.new(StartPosition)  * (Midpoint/.75)) * CFrame.Angles(math.rad(-90),0,0)) .Position  -- first 25% of the path
		local PointB = (CFrame.new(CFrame.new(EndPosition) * (Midpoint/.75) ) * CFrame.Angles(math.rad(-90),0,0)).Position  -- last 25% of the path

		local Offset = Magnitude/2
		PointA = PointA + Vector3.new(math.random(-Offset,Offset),math.random(3, 5),math.random(-Offset,Offset))
		PointB = PointB + Vector3.new(math.random(-Offset,Offset),math.random(1, 2.5),math.random(-Offset,Offset))
		local Speed = .7;
		warn("Purple Barrage")
		for i = 1, Magnitude, Speed do
			local Percent = i/Magnitude
			local Coordinate = bezierModule:cubicBezier(Percent, StartPosition, PointA, PointB, EndPosition)
			KiBlast.CFrame = KiBlast.CFrame:Lerp(CFrame.new(Coordinate, EndPosition)* CFrame.fromEulerAnglesXYZ(math.rad(10),0,math.rad(90)), Percent) 

			local nextPoint = ((i+1) < Magnitude and bezierModule:cubicBezier((i+1)/Magnitude,StartPosition,PointA,PointB,EndPosition) or bezierModule:cubicBezier(1,StartPosition,PointA,PointB,EndPosition))

			game:GetService("RunService").Heartbeat:Wait()
		end
		local Explosion = script.MegaExplosion:Clone()
		Explosion.Parent = effectsfolder
		Explosion.CFrame = CFrame.new(EndPosition)
		game.Debris:AddItem(Explosion,3)
		--Camera.Start("Soft")

		for i,v in pairs(Explosion:GetDescendants()) do if v:IsA("ParticleEmitter") then v:Emit(v:GetAttribute("EmitCount")) end end
		KiBlast.Transparency = 1
		for i,v in pairs(KiBlast:GetDescendants())do
			if v:IsA("ParticleEmitter") then
				v.Enabled = false
			end
		end



	end)
	
		
	task.wait(.25)	
	emit.enablevfx(startwater,false)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
