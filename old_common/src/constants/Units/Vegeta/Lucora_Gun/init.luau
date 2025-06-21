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
	HitDelay = 1.55, -- seconds
	HitCount = 8, -- amout of hits the skill does to split the damage visually on client
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

	local anim = AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.4)
	AnimModule.ChangeAnimSpeed(anim,2.35)
	emit.emitvfx(unit.Torso.jump)
	
	local Front = script.Front:Clone() 
	Front.Parent = workspace.Effects
	Front.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1) 
	emit.emitvfx(Front)
	debris.AddItem(Front,2.5)

	local function orbspawn(leftoright)
		local Orb = script.Orbatk2:Clone() 
		Orb.Parent = workspace.Effects
		Orb.Position = unit[leftoright].Pos.WorldPosition
		debris.AddItem(Orb,2.5)

		emit.emitvfx(unit[leftoright].Pos)
		
		emit.bezier(unit[leftoright].Pos.WorldCFrame,ColorSequence.new(Color3.fromRGB(255, 194, 41)),0.00000000005,.5,"Short")
		emit.bezier(unit[leftoright].Pos.WorldCFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.00000000005,1,"Long",false,0,0,2)

		emit.enablevfx(Orb,true)
		emit.emitvfx(Orb.Bakll)
		
		local PointA = Orb.CFrame 
		local PointB = Orb.CFrame + (rt.CFrame.LookVector * math.random(-7,7) + Vector3.new(math.random(-5,5),math.random(-7,7),math.random(-8,8)))
		local PointC = pos.CFrame + Vector3.new(math.random(-4,4),math.random(-2,2),math.random(-4,4))



		task.spawn(function()
			for d=0,1,.05 do
				Orb.CFrame = CFrame.new(Bezier(d,PointA.Position,PointB.Position,PointC.Position))
				Orb.CFrame = CFrame.lookAt(Orb.Position, pos.Position)
				wait(0.005)
			end						
			
			
			emit.emitvfx(Orb.Emit)
			emit.enablevfx(Orb,false)
			SoundWrapper:PlaySound(script["impc"], Orb, Replicated.SoundGroups.UnitSFX)

		end)
	end
	task.spawn(function()
		for i=0,4,1 do
			task.wait(.15)
			orbspawn("Left Arm")
			emit.emitvfx(Front)
		end		
	end)
	
	task.spawn(function()
		task.wait(.3)
		for i=0,4,1 do
			if 1==1 then
				orbspawn("Right Arm")

			else
				task.wait(.15)
				orbspawn("Right Arm")

			end
		end		
	end)
	
	task.wait(1)
	emit.enablevfx(Front,false)

	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
