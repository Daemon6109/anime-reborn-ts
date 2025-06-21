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
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.firstattack, unit, 1.35, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)
	
	unit.Sword.Smoke:Emit(13)
	unit.Sword.Transparency = 0
	emit.trailonoff(unit.Sword,true)


	wait(.88)
	
	--emit.emitvfx(unit.Torso.jump)


	local Slash = script.Slash:Clone() 
	Slash.Parent = workspace.Effects
	Slash.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) 
	emit.emitvfx(Slash)
	debris.AddItem(Slash,2.5)

	task.wait(.85)
	
	unit.Sword.Smoke:Emit(13)
	unit.Sword.Transparency = 1
	emit.trailonoff(unit.Sword,false)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
