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
	HitDelay = 1.5, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .25, -- delay between hits in a multi-hit move
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
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
		

	local poison = script["Poison"]:Clone() -- vfx
	poison.Parent = effectsfolder
	poison.CFrame = unit.Head.CFrame * CFrame.new(0.5,0,0)
	debris.AddItem(poison,5)

	local smoke = script:WaitForChild("Smoke"):Clone()
	smoke.Parent = effectsfolder
	smoke.CFrame = rt.CFrame * CFrame.new(0,-1.5,0)
	debris.AddItem(smoke,5)


	emit.enablevfx(smoke, true)

	task.wait(1)
	poison.Start.Parent = unit.Head
	poison.End.Parent = unit.Head
	emit.enablevfx(unit.Head.Start,true)

	task.wait(2)

	emit.enablevfx(unit.Head.Start, false)
	emit.enablevfx(smoke, false)

	task.wait(0.25)
	unit.Head.Start.Parent = poison
	unit.Head.End.Parent = poison

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
