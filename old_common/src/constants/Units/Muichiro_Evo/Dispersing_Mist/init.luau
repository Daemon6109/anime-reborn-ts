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
	HitDelay = .55, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

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
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.4)
	
	local slashse = script:FindFirstChild("Muichiro 3 Skill Hold Slashes"):Clone()
	slashse.Parent = effectsfolder
	slashse.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	debris.AddItem(slashse, 4)
	emit.emitvfx(slashse,true)
	
	local cube = script:FindFirstChild("Muichiro 3 Skill Hold Cube"):Clone()
	cube.Parent = effectsfolder
	cube.CFrame = rt.CFrame + (rt.CFrame.LookVector * 4)
	debris.AddItem(cube, 4)
	emit.enablevfx(cube,true)
	
	local btnm = script:FindFirstChild("Muichiro 3 Skill Hold Ground"):Clone()
	btnm.Parent = effectsfolder
	btnm.CFrame = rt.CFrame + (rt.CFrame.LookVector * 4) + Vector3.new(0,-1,0)
	debris.AddItem(btnm, 4)
	emit.enablevfx(btnm,true)
	
	task.wait(1.2)	
	emit.enablevfx(btnm,false)
	emit.enablevfx(cube,false)
	emit.emitvfx(slashse,false)
	
	local endvfx = script:FindFirstChild("Muichiro 3 End"):Clone()
	endvfx.Parent = effectsfolder
	endvfx.CFrame = rt.CFrame + (rt.CFrame.LookVector * 4)
	debris.AddItem(endvfx, 4)
	emit.emitvfx(endvfx)



	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
