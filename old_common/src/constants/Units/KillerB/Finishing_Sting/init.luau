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
	HitDelay = 2, -- seconds
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

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local snim = AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.4)
	
	task.wait(.5)

	emit.emitvfx(unit.Torso.jump)

	task.wait(.1)

	emit.enablevfx(unit.Torso.SwirlGold,true)

	local PointA = rt.CFrame 
	local PointB = rt.CFrame + (rt.CFrame.LookVector * 7 + Vector3.new(0,5,0))
	local PointC = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + Vector3.new(0,-.5,0)

	AnimModule.ChangeAnimSpeed(snim,0.6)

	task.spawn(function()
		for i=0,1,.022 do
			rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
			local Part = rt
			Part.CFrame = CFrame.new(Bezier(i,PointA.Position,PointB.Position,PointC.Position))
			task.wait(0.00001)
		end		

		AnimModule.ChangeAnimSpeed(snim,3.6)

		local impact = script.Atk3impact:Clone() -- vfx
		impact.Parent = workspace.Effects
		impact.Position = pos.Position + Vector3.new(0,-1,0)
		emit.emitvfx(impact)
		emit.enablevfx(unit.Torso.SwirlGold,false)
		debris.AddItem(impact,1)
	end)




	task.wait(1.45)


	unit.Torso.tp:Emit(13) -- teleporting the unit back
	task.wait(.12)
	rt.CFrame = startpos
	task.wait(.03)
	unit.Torso.tp:Emit(13)		



	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
