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
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	

	emit.emitvfx(unit)
	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -1.5)
	rt.CFrame = CFrame.new(rt.Position, pos.Position)
	task.wait(.05)
	emit.emitvfx(unit)
	
	local start = script:FindFirstChild("Muichiro 2 Skill Spawn"):Clone()
	start.Parent = effectsfolder
	start.Position = rt.Position + Vector3.new(0,-1,0)
	debris.AddItem(start, 4)
	emit.emitvfx(start)
	
	local vfxmain = script:FindFirstChild("Muichiro 2 Skill Hold"):Clone()
	vfxmain.Parent = effectsfolder
	vfxmain.Position = rt.Position + Vector3.new(0,-1,0)
	debris.AddItem(vfxmain, 4)
	emit.enablevfx(vfxmain,true)
	
	task.wait(.75)
	
	emit.enablevfx(vfxmain,false)

	local endvfx = script:FindFirstChild("Muichiro 2 Skill End"):Clone()
	endvfx.Parent = effectsfolder
	endvfx.Position = rt.Position + Vector3.new(0,-1,0)+ (rt.CFrame.LookVector * 1.5)
	debris.AddItem(endvfx, 4)
	emit.emitvfx(endvfx)	
	AnimModule.ChangeAnimSpeed(ANIMM,11)

	task.wait(.6)

	emit.emitvfx(unit)
	rt.CFrame = startpos
	task.wait(.05)
	emit.emitvfx(unit)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
