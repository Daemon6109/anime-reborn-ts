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
	HitDelay = .6, -- seconds
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
	
	if unit:HasTag("Building") then
		repeat task.wait() until not unit:HasTag("Building")
	end
	
	unit:AddTag("Building")
	
	local oldbuilding = unit:FindFirstChild("FirstBuilding")
	print(oldbuilding)
	
	if oldbuilding then
		oldbuilding:Destroy()
	end
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	SoundWrapper:PlaySound(script["Sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local oldbuilding = unit:FindFirstChild("Building")
	local building = script.FirstBuilding:Clone()
	building.Parent = unit
	building.PrimaryPart.CFrame = rt.CFrame + (rt.CFrame.RightVector * 6) + Vector3.new(0,2.5,0) 
	
	emit.emitvfx(building)

	unit:RemoveTag("Building")
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
