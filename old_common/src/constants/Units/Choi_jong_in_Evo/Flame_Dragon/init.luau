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
	HitDelay = 1.3, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
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
	
	task.wait(.35)
	
	emit.enablevfx(unit.Torso,true)
	
	local Dragon = script.Dragon:Clone() 
	Dragon.Parent = effectsfolder
	Dragon.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2.5)
	
	emit.emitvfx(Dragon)
	emit.enablevfx(Dragon,true)

	local PointA = Dragon.CFrame 
	local PointB = Dragon.CFrame + (rt.CFrame.LookVector * 7) + Vector3.new(0,13.5,0)
	local PointC = pos.CFrame + (rt.CFrame.LookVector * 1.5)



	task.spawn(function()
		for d=0,1,.02 do
			Dragon.CFrame = CFrame.new(Bezier(d,PointA.Position,PointB.Position,PointC.Position))
			Dragon.CFrame = CFrame.lookAt(Dragon.Position, pos.Position)
			task.wait(0.005)
		end					

		Dragon.Transparency = 1
		SoundWrapper:PlaySound(script.Parent.Explosion, rt, Replicated.SoundGroups.UnitSFX)
		local impact = script["Explosion"]:Clone() 
		impact.Parent = effectsfolder
		impact.Position = Dragon.Position + Vector3.new(0,-2.5,0)
		emit.emitvfx(impact,true)
		emit.enablevfx(Dragon,false)
		Dragon.Transparency = 1	
			
		debris.AddItem(impact,3)
		emit.enablevfx(unit.Torso,false)


	end)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
