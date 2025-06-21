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
	HitDelay = 1.7, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	
	unit.Gun.cube.Flares:Emit(15)
	unit.Gun.cube.Transparency = 1
	
	unit.GRENADE.Flares:Emit(15)
	unit.GRENADE.Transparency = 0
	
	task.wait(.9)
	
	
	local grenade = script.GRENADE:Clone() 
	grenade.Parent = effectsfolder
	grenade.CFrame = unit.GRENADE.CFrame
	unit.GRENADE.Transparency = 1

	local PointA = grenade.CFrame 
	local PointB = grenade.CFrame + (rt.CFrame.LookVector * 5) + Vector3.new(0,3.5,0)
	local PointC = pos.CFrame + (rt.CFrame.LookVector * 1.5)



	task.spawn(function()
		for d=0,1,.05 do
			grenade.CFrame = CFrame.new(Bezier(d,PointA.Position,PointB.Position,PointC.Position))
			grenade.CFrame = CFrame.lookAt(grenade.Position, pos.Position)
			task.wait(0.005)
		end					
		
		grenade.Transparency = 1

		local impact = script["Grenade Impact"]:Clone() 
		impact.Parent = effectsfolder
		impact.CFrame = grenade.CFrame
		emit.emitvfx(impact,true)

		debris.AddItem(impact,3)


	end)
	
	
	task.wait(.3)
	
	unit.Gun.cube.Flares:Emit(15)
	unit.Gun.cube.Transparency = 0
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
